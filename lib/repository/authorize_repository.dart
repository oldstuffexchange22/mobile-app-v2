import 'package:flutter/cupertino.dart';
import '../model/request/login_firebase_request.dart';
import '../model/response/login_firebase_response.dart';

abstract class AuthorizeRepository {
  Future<LoginFirebaseResponse> firebaseSignIn(
      String url, LoginFirebaseRequest request);
}
