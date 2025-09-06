import 'package:flutter/material.dart';

class SizeConfig {
  static double screenHeight = 0.0;
  static double screenWidth = 0.0;

  static void init (BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  static double getProportionateHeight (double inputHeight) {
    return (inputHeight/812) * screenHeight;
  }

  static double getProportionatewidth(double inputWidth) {
    return (inputWidth/812) * screenWidth;
  }
}