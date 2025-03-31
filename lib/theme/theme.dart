import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';

// Color primaryClr=Colors.white;
// Color primaryClr=Colors.white;
Color primaryClr = Colors.white;
const Color darkGreClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: Colors.white,
      brightness: Brightness.light);

  static final dark = ThemeData(
      backgroundColor: darkGreClr,
      primaryColor: darkGreClr,
      brightness: Brightness.dark);
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    // fontFeatures: [],
      textStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
        color: Get.isDarkMode?Colors.grey[400]:Colors.grey,
  ));
}
TextStyle get headingStyle {
  return GoogleFonts.lato(
      // fontFeatures: [],

      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode?Colors.white:Colors.black,
      ));
}
