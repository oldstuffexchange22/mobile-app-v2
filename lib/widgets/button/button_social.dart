import 'package:flutter/material.dart';

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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Image.asset(assetName),
            const SizedBox(
              width: 50,
            ),
            Text(content,
                style: const TextStyle(color: Colors.black, fontSize: 16.0)),
            Opacity(opacity: 0.0, child: Image.asset(assetName))
          ],
        ),
      ),
    );
  }
}
