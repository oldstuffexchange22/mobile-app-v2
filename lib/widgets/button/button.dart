import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault(
      {Key? key,
      this.width = 342,
      this.height = 56,
      required this.content,
      this.color,
      required this.voidCallBack})
      : super(key: key);
  final double? width;
  final double? height;
  final String content;
  final Color? color;
  final VoidCallback voidCallBack;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: voidCallBack,
        style: ElevatedButton.styleFrom(
          primary: kColorPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(content),
      ),
    );
  }
}
