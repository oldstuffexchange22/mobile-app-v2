import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:old_stuff_exchange/view_model/provider/aparment_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/building_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/home_page_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';
import 'package:provider/provider.dart';

import '../../model/request/login_firebase_request.dart';
import '../../repository/implement/authorize_repository_implement.dart';
import '../url_api/url_api.dart';

class SignInProvider with ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final SecureStorage secureStorage = SecureStorage();
  final googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        googleSignIn.signInSilently();
        context.loaderOverlay
            .show(widget: const CustomOverlay(content: 'Đang đăng nhập...'));
        final googleAuth = await googleUser.authentication;
        String? urlPhoto = googleUser.photoUrl;
        String? displayName = googleUser.displayName;
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
              await secureStorage.writeSecureData('photoUrl', urlPhoto ?? '');
              await secureStorage.writeSecureData(
                  'displayName', displayName ?? '');
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

  Future<void> signOut(BuildContext context) async {
    context.loaderOverlay.show();
    final SecureStorage secureStorage = SecureStorage();
    secureStorage.deleteAll();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/signInPage', (route) => false);
    showToastSuccess('Đăng xuất thành công');
    context.loaderOverlay.hide();
    Phoenix.rebirth(context);
    await googleSignIn.disconnect();
  }
}
