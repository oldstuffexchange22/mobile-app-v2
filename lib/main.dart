import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/routes/routes.dart';
import 'package:old_stuff_exchange/view_model/provider/main_provider/main_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MainProviders.providers,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Old stuff exchange',
          theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Roboto"),
          initialRoute: "/signInPage",
          routes: Routes.routes),
    );
  }
}
