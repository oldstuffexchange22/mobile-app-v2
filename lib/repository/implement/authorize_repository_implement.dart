import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';

import '../../model/response/login_firebase_response.dart';
import '../../model/request/login_firebase_request.dart';
import '../authorize_repository.dart';

class AuthorizeRepImp implements AuthorizeRepository {
  @override
  Future<LoginFirebaseResponse> firebaseSignIn(
      String url, LoginFirebaseRequest request) async {
    var result = LoginFirebaseResponse();
    try {
      Response response = await Dio().post(url, data: {"token": request.token});
      result = LoginFirebaseResponse.fromJson(response.data);
    } on DioError catch (e) {
      // showToastFail(e.response?.data['message']);
      print(e);
    }
    return result;
  }
}
