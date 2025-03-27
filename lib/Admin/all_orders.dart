import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream<QuerySnapshot>? orderStream;

  getontheload() async {
    orderStream = await DatabaseMethods().getAllOrders();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allOrders() {
    return StreamBuilder<QuerySnapshot>(
      stream: orderStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while waiting
        }
        if (snapshot.hasError) {
          return Center(
              child: Text(
                  'Error: ${snapshot.error}')); // Show error message if there's an error
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
                  'No orders yet, place your order.')); // Show message if no orders are found
        }

        return ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        ds["ProductImage"],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Name"],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ds["Email"],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            ds["Product"],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "\$ ${ds["Price"]}",
                            style: TextStyle(
                              color: Color(0xFFfd6d3e),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Order ID: ${ds.id}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async {
                                await DatabaseMethods().updateStatus(ds.id);
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 30, top: 10),
                                width: 100,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 213, 55, 2),
                                ),
                                child: Center(
                                  child: Text(
                                    "Done",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          title: Center(
            child: Text(
              "All Orders",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: allOrders(),
              ),
            ],
          ),
        ));
  }
}
