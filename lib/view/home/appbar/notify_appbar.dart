import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class NotifyAppBarContainer extends StatelessWidget {
  const NotifyAppBarContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text('Bài mua', style: PrimaryFont.extraLight(22)),
    );
  }
}
