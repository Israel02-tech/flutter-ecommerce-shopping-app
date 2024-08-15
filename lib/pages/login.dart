import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_shopping_app/pages/bottomnav.dart';
import 'package:ecommerce_shopping_app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_pref.dart';
import '../widget/support_widget.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> logSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Current SharedPreferences:");
    print("UserName: ${prefs.getString(SharedPreferenceHelper.userNamekey)}");
    print("UserImage: ${prefs.getString(SharedPreferenceHelper.userImagekey)}");
  }

  Future<void> userLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        email = emailController.text;
        password = passwordController.text;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;

        if (user != null) {
          // Clear previous user data
          await SharedPreferenceHelper().clear();

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            Map<String, dynamic>? userData =
                userDoc.data() as Map<String, dynamic>?;

            if (userData != null) {
              print(
                  "Fetched user data: $userData"); // Debugging line to verify data
              String userName = userData['Name'] ?? "Unknown";
              String userImage = userData['Image'] ?? "";
              await SharedPreferenceHelper().saveUserName(userName);
              await SharedPreferenceHelper().saveUserImage(userImage);
              // Log SharedPreferences content for verification
              await logSharedPreferences();
            } else {
              print("User data is null.");
            }
          } else {
            print("User document does not exist.");
          }

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNav(),
              ));
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case "invalid-email":
            message = "Invalid email address.";
            break;
          case "user-disabled":
            message = "User account is disabled.";
            break;
          case "user-not-found":
            message = "No user found with this email.";
            break;
          case "wrong-password":
            message = "Wrong password provided.";
            break;
          default:
            message = "Error: ${e.message}";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xfff2f2f2),
            content: Text(
              message,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        );
      } catch (e) {
        print("An unexpected error occurred: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xfff2f2f2),
            content: Text(
              "An error occurred: ${e.toString()}",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset("images/login.png", height: 300),
                ),
                Center(
                  child: Text(
                    "Sign In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Please enter your details below to continue",
                  textAlign: TextAlign.center,
                  style: AppWidget.lightTextStyle(),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Email",
                  style: AppWidget.semiBoldTextStyle(),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Password",
                  style: AppWidget.semiBoldTextStyle(),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 226, 94, 6),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    await userLogin();
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppWidget.lightTextStyle(),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 226, 94, 6),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
