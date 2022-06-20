import 'package:fluttertoast/fluttertoast.dart';
import 'package:old_stuff_exchange/config/themes/theme.dart';

void showToastSuccess(String mess) => Fluttertoast.showToast(
    msg: mess,
    backgroundColor: kColorGreenToast,
    gravity: ToastGravity.TOP_RIGHT,
    timeInSecForIosWeb: 3);
void showToastFail(String mess) => Fluttertoast.showToast(
    msg: mess,
    backgroundColor: kColorRedToast,
    gravity: ToastGravity.TOP_RIGHT,
    timeInSecForIosWeb: 3);
