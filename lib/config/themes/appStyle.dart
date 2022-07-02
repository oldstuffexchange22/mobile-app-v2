import 'package:flutter/material.dart';

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

}
