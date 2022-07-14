import 'dart:io';

import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/repository/user_repository.dart';
import 'package:old_stuff_exchange/utils/option_request.dart';
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
      user = User.fromJson(response.data['data']);
    } catch (e) {
      showToastFail('Some thing went wrong call api get user id');
    }
    return user;
  }

  @override
  Future<User> updateAddress(String userId, String buildingId) async {
    late User user;
    try {
      Options options = await OptionRequest.optionAuthorize();
      Map<String, dynamic> data = {'userId': userId, 'buildingId': buildingId};
      Response response = await Dio().put('${UrlApi.userController}/address',
          options: options, queryParameters: data);
      user = User.fromJson(response.data['data']);
      await secureStorage.writeSecureData(
          'apartmentId', user.building?.apartmentId ?? '');
    } on DioError catch (e) {
      showToastFail('Some thing went wrong call api user');
    }
    return user;
  }
}
