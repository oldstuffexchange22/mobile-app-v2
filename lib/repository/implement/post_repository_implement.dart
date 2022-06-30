import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/repository/post_repository.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class PostRepImp implements PostRepository {
  final SecureStorage secureStorage = SecureStorage();
  @override
  Future<List<Post>?> getList(String status, int pageIndex, int pageSize,
      String? filterWith, String? filterValue, String? categoryId) async {
    late List<Post>? result;
    try {
      String token = await secureStorage.readSecureData('token');
      Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
      String apartmentId = tokenDecode['apartmentId'];
      Options requestOptions =
          Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      Response response = await Dio().get(UrlApi.postController,
          options: requestOptions,
          queryParameters: {
            'apartmentId': apartmentId,
            'pageIndex': pageIndex,
            'pageSize': pageSize,
            'filterWith': filterWith,
            'filterValue': filterValue,
            'categoryId': categoryId,
            'status': status
          });
      result =
          (response.data['data'] as List).map((e) => Post.fromJson(e)).toList();
      
    } catch (e) {
      print(e);
      result = null;
    }
    return result;
  }
}
