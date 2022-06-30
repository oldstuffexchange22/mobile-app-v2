

import 'package:flutter/cupertino.dart';

class PrimaryFont {
  static String fontFamily = 'Blinker';
  static TextStyle regular(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: size);
  }
  static TextStyle semiBold(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w600, fontSize: size);
  }

  static TextStyle thin(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w100, fontSize: size);
  }

  static TextStyle light(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w300, fontSize: size);
  }
  static TextStyle extraLight(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: size);
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