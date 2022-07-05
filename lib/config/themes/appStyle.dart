import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';

class AppStyle {
  static btnPrimaryStyle() => ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      )),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 14, fontFamily: 'Blinker')),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF6A74CF)));
  static btnUploadStyle() => ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      )),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 12, fontFamily: 'Blinker')),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF6A74CF)));
  static btnCreateStyle() => ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      )),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 14, fontFamily: 'Blinker')),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 34, vertical: 8)),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFF6A74CF)));
  static btnDeleteStyle() => ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.red),
      padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 12)));

  static decorationBgPrimary() => BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kColorBackGroundStart, kColorBackGroundEnd]));
}
