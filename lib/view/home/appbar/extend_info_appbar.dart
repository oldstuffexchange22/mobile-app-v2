

import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class ExtendAppBarContainer extends StatelessWidget {
  const ExtendAppBarContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Thêm',
        style: PrimaryFont.extraLight(22),
      ),
    );
  }
}