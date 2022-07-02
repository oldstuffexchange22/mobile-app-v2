import 'dart:io';

import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/building.dart';
import 'package:old_stuff_exchange/repository/building_repository.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class BuildingRepImp implements BuildingRep {
  final SecureStorage secureStorage = SecureStorage();
  @override
  Future<List<Building>> getList(String apartmentId) async {
    late List<Building> result;
    try {
      String token = await secureStorage.readSecureData('token');
      Options optionsRequest =
          Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      Response response = await Dio().get(UrlApi.buildingController,
          options: optionsRequest,
          queryParameters: {'apartmentId': apartmentId});
      result = (response.data['data'] as List)
          .map((e) => Building.fromJson(e))
          .toList();
    } catch (_) {
      showToastFail('Some went wrong when call api building');
    }
    return result;
  }
}
