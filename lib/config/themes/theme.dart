import 'package:flutter/material.dart';

const kColorPrimary = Color(0xFF69BF6F);
const kColorGreenToast = Color(0xFF1D741B);
const kColorRedToast = Color(0xFFff0000);

class PrimaryFont {
  static String fontFamily = 'Roboto';
  static TextStyle medium(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: size);
  }

  static TextStyle thin(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w100, fontSize: size);
  }

  static TextStyle light(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w300, fontSize: size);
  }

  static TextStyle bold(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w700, fontSize: size);
  }

  static TextStyle black(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w900, fontSize: size);
  }
}

extension GetOrientation on BuildContext {
  Orientation get orientation => MediaQuery.of(this).orientation;
}

extension GetSize on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}
