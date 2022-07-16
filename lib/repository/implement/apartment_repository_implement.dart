import 'dart:io';

import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/apartment.dart';
import 'package:old_stuff_exchange/repository/apartment_repository.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class ApartmentReqImp implements ApartmentRep {
  final SecureStorage secureStorage = SecureStorage();
  @override
  Future<List<Apartment>> getList() async {
    late List<Apartment> result;
    try {
      String token = await secureStorage.readSecureData('token');
      Options optionsRequest =
          Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      Map<String, dynamic> queryParams = {'isBuildingsNull': false};
      Response response = await Dio().get(UrlApi.apartmentController,
          options: optionsRequest, queryParameters: queryParams);
      result = (response.data['data'] as List)
          .map((item) => Apartment.fromJson(item))
          .toList();
    } catch (e) {
      showToastFail('Some thing went wrong when call apartment $e');
    }
    return result;
  }
}
