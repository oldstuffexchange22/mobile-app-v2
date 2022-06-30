import 'package:flutter/cupertino.dart';

class ExtendInfoView extends StatefulWidget {
  const ExtendInfoView({Key? key}) : super(key: key);

  @override
  State<ExtendInfoView> createState() => _ExtendInfoViewState();
}

class _ExtendInfoViewState extends State<ExtendInfoView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Extend view'),
    );
  }
}