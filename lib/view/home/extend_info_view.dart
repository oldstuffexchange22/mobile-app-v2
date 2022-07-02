import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class ExtendInfoView extends StatefulWidget {
  const ExtendInfoView({Key? key}) : super(key: key);

  @override
  State<ExtendInfoView> createState() => _ExtendInfoViewState();
}

class _ExtendInfoViewState extends State<ExtendInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
      alignment: Alignment.center,
      child: Text(
        'Thêm',
        style: PrimaryFont.extraLight(22),
      ),
    ),
      ),
    );
  }
}