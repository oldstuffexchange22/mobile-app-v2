

import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class ManagePostAppBarContainer extends StatelessWidget {
  const ManagePostAppBarContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Quản lí tin',
        style: PrimaryFont.extraLight(22),
      ),
    );
  }
}