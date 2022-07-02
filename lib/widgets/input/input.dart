

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class InputApp extends StatelessWidget {
  const InputApp(
      {Key? key,
      required this.screenSize,
      required this.icon,
      required this.label,
      required this.controller})
      : super(key: key);

  final Size screenSize;
  final Icon icon;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.7,
      height: screenSize.height * 0.07,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 50),
            fillColor: kColorWhite,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: kColorWhite,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            prefixIcon: icon,
            labelText: label,
            labelStyle: MaterialStateTextStyle.resolveWith((states) {
              return PrimaryFont.regular(16).copyWith(color: kColorText);
            })),
      ),
    );
  }
}