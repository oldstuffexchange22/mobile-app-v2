import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/view/home/home_page.dart';
import 'package:old_stuff_exchange/view/login/signin_page.dart';
import 'package:old_stuff_exchange/view/login/update_address_page.dart';

class Routes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    "/signInPage": (context) => const SignInPage(),
    "/homePage": (context) => const HomePage(),
    "/updateAddressPage": (context) => const UpdateAddressPage()
  };
}
