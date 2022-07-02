import 'dart:io';

import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

class OptionRequest {
  static final SecureStorage secureStorage = SecureStorage();
  static Future<Options> optionAuthorize() async {
    String token = await secureStorage.readSecureData('token');
    Options optionsRequest =
        Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    return optionsRequest;
  }
}
