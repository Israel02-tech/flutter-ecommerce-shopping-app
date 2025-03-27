// ignore_for_file: unused_import

import 'package:ecommerce_shopping_app/Admin/add_product.dart';
import 'package:ecommerce_shopping_app/Admin/admin_login.dart';
import 'package:ecommerce_shopping_app/Admin/all_orders.dart';
import 'package:ecommerce_shopping_app/Admin/home_admin.dart';
import 'package:ecommerce_shopping_app/pages/home.dart';
import 'package:ecommerce_shopping_app/pages/login.dart';
import 'package:ecommerce_shopping_app/pages/profile.dart';
import 'package:ecommerce_shopping_app/pages/signup.dart';
import 'package:ecommerce_shopping_app/services/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'pages/bottomnav.dart';
import 'pages/onboarding.dart';
import 'pages/product_detail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishabelkey;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}
