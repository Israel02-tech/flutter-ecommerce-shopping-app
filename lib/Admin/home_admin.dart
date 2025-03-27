import 'package:ecommerce_shopping_app/Admin/add_product.dart';
import 'package:ecommerce_shopping_app/Admin/all_orders.dart';
import 'package:ecommerce_shopping_app/widget/support_widget.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Home Admin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (value) => AddProduct(),
                  ),
                );
              },
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 40,
                      ),
                      SizedBox(width: 15),
                      Text("Add Product", style: AppWidget.boldTextFeildStyle())
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (value) => AllOrders()));
              },
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        size: 40,
                      ),
                      SizedBox(width: 15),
                      Text("All Order", style: AppWidget.boldTextFeildStyle())
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
