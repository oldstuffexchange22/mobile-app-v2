import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/view/home/extend_view/recharge_money.dart';
import 'package:old_stuff_exchange/view/home/home_page.dart';
import 'package:old_stuff_exchange/view/login/signin_page.dart';
import 'package:old_stuff_exchange/view/login/update_address_page.dart';
import 'package:old_stuff_exchange/view/post/create_post.dart';
import 'package:old_stuff_exchange/view/post/payment_post.dart';

class Routes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    "/signInPage": (context) => const SignInPage(),
    "/homePage": (context) => const HomePage(),
    "/updateAddressPage": (context) => const UpdateAddressPage(),
    "/createPostPage": (context) => const CreatePost(),
    "/paymentPostPage": (context) => const PaymentPost(),
    "/rechargeMoneyPage" : (context) => const RechargeMoneyPage()
  };
}
