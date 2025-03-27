import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shopping_app/Admin/home_admin.dart';
import 'package:flutter/material.dart';
import '../widget/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernamecontroller;
    userpasswordcontroller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset("images/Admin Login.png", height: 350),
              ),
              Center(
                child: Text(
                  "Admin Panel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Username",
                style: AppWidget.semiBoldTextStyle(),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 226, 226, 226),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Username",
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Password",
                style: AppWidget.semiBoldTextStyle(),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 226, 226, 226),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  obscureText: true,
                  controller: userpasswordcontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  loginAdmin();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 226, 94, 6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      for (var result in snapshot.docs) {
        if (result.data()["username"] != usernamecontroller.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Your Id is not correct",
                  style: TextStyle(fontSize: 20))));
        } else if (result.data()["password"] !=
            userpasswordcontroller.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content:
                  Text("Incorrect Password", style: TextStyle(fontSize: 20))));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeAdmin()));
        }
      }
    });
  }
}
