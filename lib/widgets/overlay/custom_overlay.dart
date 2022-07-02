import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class CustomOverlay extends StatefulWidget {
  const CustomOverlay({Key? key, this.content = 'Vui lòng chờ ^-^'})
      : super(key: key);
  final String content;

  @override
  State<CustomOverlay> createState() => _CustomOverlayState();
}

class _CustomOverlayState extends State<CustomOverlay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 16,
        ),
        Text(
          widget.content,
          style: PrimaryFont.extraLight(16).copyWith(color: kColorWhite),
        )
      ],
    );
  }
}
