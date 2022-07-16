import 'package:old_stuff_exchange/view/login/update_address_page.dart';
import 'package:old_stuff_exchange/view_model/provider/aparment_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/building_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/home_page_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/post_bought_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/post_create_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/post_payment_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/post_sale_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/update_address_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../sign_in_provider.dart';

class MainProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<SignInProvider>(
        create: ((context) => SignInProvider())),
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider<ApartmentProvider>(
      create: (context) => ApartmentProvider(),
    ),
    ChangeNotifierProvider<BuildingProvider>(
        create: ((context) => BuildingProvider())),
    ChangeNotifierProvider<UpdateAddressProvider>(
        create: (context) => UpdateAddressProvider()),
    ChangeNotifierProvider<PostProvider>(create: (context) => PostProvider()),
    ChangeNotifierProvider<PostPaymentProvider>(
        create: ((context) => PostPaymentProvider())),
    ChangeNotifierProvider<PostSaleProvider>(
        create: ((context) => PostSaleProvider())),
    ChangeNotifierProvider<PostBoughtProvider>(
        create: ((context) => PostBoughtProvider())),
    ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider())
  ];
}
