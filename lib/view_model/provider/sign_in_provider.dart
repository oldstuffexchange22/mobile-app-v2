import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

import '../../model/request/login_firebase_request.dart';
import '../../repository/implement/authorize_repository_implement.dart';
import '../url_api/url_api.dart';

class SignInProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final SecureStorage secureStorage = SecureStorage();
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final userCredential = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          User? user = userCredential.user;
          if (user != null) {
            String token = await user.getIdToken();
            AuthorizeRepImp()
                .firebaseSignIn(
                    UrlApi.signinFirebase, LoginFirebaseRequest(token: token))
                .then((value) async {
              print(value.token);
              final navigator = Navigator.of(context);
              await secureStorage.writeSecureData('token', value.token ?? '');
              showToastSuccess('Login success');
              navigator.pushReplacementNamed('/homePage');
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
