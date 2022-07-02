import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:provider/provider.dart';

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
        context.loaderOverlay.show();
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final userCredential = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          User? user = userCredential.user;
          if (user != null) {
            String token = await user.getIdToken();
            await AuthorizeRepImp()
                .firebaseSignIn(
                    UrlApi.signinFirebase, LoginFirebaseRequest(token: token))
                .then((value) async {
              final navigator = Navigator.of(context);
              await secureStorage.writeSecureData('token', value.token ?? '');

              Map<String, dynamic> tokenDecode =
                  Jwt.parseJwt(value.token ?? '');
              String apartmentId = tokenDecode['apartmentId'];
              if (apartmentId.isEmpty) {
                navigator.pushNamed('/updateAddressPage');
              } else {
                navigator.pushReplacementNamed('/homePage');
                showToastSuccess('Login success');
              }
              context.loaderOverlay.hide();
            });
          }
        }
      }
    } on PlatformException catch (e) {
      showToastFail('Please make sure connecting internet');
      final navigator = Navigator.of(context);
      context.loaderOverlay.hide();
      navigator.pushReplacementNamed('/signInPage');
    } catch (e) {
      showToastFail('Something when wrong');
      final navigator = Navigator.of(context);
      context.loaderOverlay.hide();
      navigator.pushReplacementNamed('/signInPage');
    }
  }
}
