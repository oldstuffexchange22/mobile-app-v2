import 'dart:io';

import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/repository/user_repository.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class UserRepImp implements UserRepository {
  final SecureStorage secureStorage = SecureStorage();
  @override
  Future<User> getUserById(String id) async {
    late User user;
    try {
      String token = await secureStorage.readSecureData('token');
      Options optionsRequest =
          Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      Response response = await Dio()
          .get('${UrlApi.userController}/$id', options: optionsRequest);
      user = User.fromJon(response.data['data']);
    } catch (e) {
      print(e);
    }
    return user;
  }
}
