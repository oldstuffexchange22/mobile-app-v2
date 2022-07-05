import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class InputApp extends StatelessWidget {
  const InputApp(
      {Key? key,
      this.minLines = 1,
      this.maxLines,
      this.height,
      this.width,
      required this.icon,
      this.label,
      this.isRequired,
      required this.controller})
      : super(key: key);

  final Icon icon;
  final String? label;
  final TextEditingController controller;
  final int? maxLines;
  final int minLines;
  final double? width;
  final double? height;
  final bool? isRequired;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        validator: (String? value) {
          if (isRequired == true && (value == null || value.isEmpty)) {
            return 'Không thể bỏ trống';
          }
          return null;
        },
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                )),
            errorStyle: PrimaryFont.extraLight(10)
                .copyWith(color: Colors.red, height: 1),
            contentPadding: const EdgeInsets.all(16),
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.red, width: 2),
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

class InputNumberApp extends StatelessWidget {
  const InputNumberApp(
      {Key? key,
      this.minLines = 1,
      this.maxLines,
      this.height,
      this.width,
      required this.icon,
      this.label,
      this.isRequired,
      required this.controller})
      : super(key: key);

  final Icon icon;
  final String? label;
  final TextEditingController controller;
  final int? maxLines;
  final int minLines;
  final double? width;
  final double? height;
  final bool? isRequired;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        validator: (String? value) {
          if (isRequired == true && (value == null || value.isEmpty)) {
            return 'Không thể bỏ trống';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                )),
            errorStyle: PrimaryFont.extraLight(10)
                .copyWith(color: Colors.red, height: 1),
            contentPadding: const EdgeInsets.all(16),
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.red, width: 2),
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
