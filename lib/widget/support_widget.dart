import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFeildStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle lightTextStyle() {
    return TextStyle(
      color: Colors.black54,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle hintTextStyle() {
    return TextStyle(
      color: Colors.grey,
      fontSize: 20,
    );
  }

  static TextStyle semiBoldTextStyle() {
    return TextStyle(
      fontSize: 20.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle productDetailTextFeildStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
    );
  }
}
