import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class ButtonSocial extends StatelessWidget {
  const ButtonSocial(
      {Key? key,
      this.width = 342,
      this.height = 56,
      required this.content,
      this.color,
      required this.voidCallBack,
      required this.assetName})
      : super(key: key);
  final double? width;
  final double? height;
  final String content;
  final Color? color;
  final VoidCallback voidCallBack;
  final String assetName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: voidCallBack,
        style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1.0, color: Colors.blue),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            backgroundColor: kColorBlue),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 12,
            ),
            SizedBox(width: 24, height: 40, child: Image.asset(assetName)),
            const SizedBox(
              width: 16,
            ),
            Text(content,
                style: PrimaryFont.regular(14).copyWith(color: kColorWhite)),
            Opacity(opacity: 0.0, child: Image.asset(assetName))
          ],
        ),
      ),
    );
  }
}
