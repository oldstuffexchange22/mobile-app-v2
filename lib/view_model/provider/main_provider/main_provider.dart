import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../sign_in_provider.dart';

class MainProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<SignInProvider>(
        create: ((context) => SignInProvider()))
  ];
}
