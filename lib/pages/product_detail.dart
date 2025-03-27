import 'dart:convert';

import 'package:ecommerce_shopping_app/services/constant.dart';
import 'package:ecommerce_shopping_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../services/shared_pref.dart';
import '../widget/support_widget.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  String image, name, detail, price;
  ProductDetail(
      {super.key,
      required this.image,
      required this.name,
      required this.detail,
      required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, email, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Implement some initialization operations here.
    ontheload();
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef5f1),
      body: Container(
        padding: EdgeInsets.only(
          top: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(
                    widget.image,
                    // height: 500,
                    // width: 800,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name,
                            style: AppWidget.productDetailTextFeildStyle(),
                          ),
                          Text(
                            "\$${widget.price}",
                            style: TextStyle(
                              color: Color(0xFFfd6d3e),
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Details",
                        style: AppWidget.semiBoldTextStyle(),
                      ),
                      Text(
                        widget.detail,
                        style: AppWidget.lightTextStyle(),
                      ),
                      SizedBox(height: 95),
                      GestureDetector(
                        onTap: () async {
                          await makePayment(widget.price);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Color(0xFFfd6d3e),
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "Buy Now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      print("Creating payment intent......");
      paymentIntent = await createPaymentIntent(amount, "USD");
      print("Payment intent created: $paymentIntent");
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent?['client_secret'],
            style: ThemeMode.dark,
            merchantDisplayName: 'Israel',
          ))
          .then((value) {});

      await displayPaymentSheet();
    } catch (e, s) {
      print("Exception in makePayment:$e\n$s");
    }
  }

  Future<void> displayPaymentSheet() async {
    //Uploding the details of the order placed to the firebase
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String, dynamic> orderInfoMap = {
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": email,
          "Image": image,
          "ProductImage": widget.image,
          "Status": "On the Way",
        };
        //Saving the oderdetails to the database the database
        await DatabaseMethods().orderDetails(orderInfoMap);
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          Text("Payment Succesfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error presentPaymentSheet :-------> $error $stackTrace");
      });
    } on StripeException catch (e) {
      print("StripeException in displayPaymentSheet: $e");
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (e) {
      print("Exception in displayPaymentSheet:$e");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      String cleanAmount = amount.replaceAll(RegExp(r'[^0-9]'), '');
      Map<String, dynamic> body = {
        "amount": calculateAmount(cleanAmount),
        "currency": currency,
        "payment_method_types[]": "card"
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: {
          "Authorization": "Bearer $secretkey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body.map((key, value) => MapEntry(key, value.toString())),
      );
      return jsonDecode(response.body);
    } catch (err) {
      print("Error creating payment intent: ${err.toString()}");
      rethrow;
    }
  }
}

int calculateAmount(String amount) {
  final int calculatedAmount = int.parse(amount) * 100;
  return calculatedAmount;
}
