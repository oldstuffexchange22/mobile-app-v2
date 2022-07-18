import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:old_stuff_exchange/config/constrant/post_status.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/model/entity/product.dart';
import 'package:old_stuff_exchange/model/request/post_create.dart';
import 'package:old_stuff_exchange/model/request/product_create.dart';
import 'package:old_stuff_exchange/repository/post_repository.dart';
import 'package:old_stuff_exchange/utils/option_request.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';
import 'package:uuid/uuid.dart';

class PostRepImp implements PostRepository {
  final SecureStorage secureStorage = SecureStorage();
  @override
  Future<List<Post>> getList(String status, int pageIndex, int pageSize,
      String? filterWith, String? filterValue, String? categoryId) async {
    late List<Post> result;
    try {
      String token = await secureStorage.readSecureData('token');
      Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
      String apartmentId = tokenDecode['apartmentId'];
      String userId = tokenDecode['id'];
      Options requestOptions =
          Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
      Response response = await Dio().get(UrlApi.postController,
          options: requestOptions,
          queryParameters: {
            'exceptAuthorId': userId,
            'apartmentId': apartmentId,
            'page': pageIndex,
            'pageSize': pageSize,
            'filterWith': filterWith,
            'filterValue': filterValue,
            'categoryId': categoryId,
            'status': status
          });
      result =
          (response.data['data'] as List).map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      showToastFail('Api list post error $e');
    }
    return result;
  }

  @override
  Future<Post?> create(CreatePost post) async {
    Post? result;
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Response response = await Dio().post(UrlApi.postController,
          data: post.toJson(), options: optionRequest);
      result = Post.fromJson(response.data['data']);
    } on DioError catch (e) {
      showToastFail('Api create post error dio $e');
    } catch (e) {
      showToastFail('Api create post error $e');
    }
    return result;
  }

  @override
  Future<List<Post>> getPostStatus(String status) async {
    List<Post> result = [];
    try {
      String token = await secureStorage.readSecureData('token');
      Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
      String userId = tokenDecode['id'];
      Options optionRequest = await OptionRequest.optionAuthorize();
      Response response = await Dio().get(
          '${UrlApi.postController}/user/$userId',
          options: optionRequest,
          queryParameters: {
            "status": status,
            "pageSize": 30,
            "isOrderLastUpdate": true
          });
      result =
          (response.data['data'] as List).map((e) => Post.fromJson(e)).toList();
    } on DioError catch (e) {
      showToastFail('Api get status post$e');
    } catch (e) {
      showToastFail('Api get status post$e');
    }
    return result;
  }

  @override
  Future<Post?> buy(String postId, String walletType) async {
    Post? result;
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Map<String, dynamic> dataRequest = {
        "postId": postId,
        "walletType": walletType,
        "status": PostStatus.DELIVERY
      };
      Response response = await Dio().put('${UrlApi.postController}/status',
          options: optionRequest, data: dataRequest);
      result = Post.fromJson(response.data['data']);
    } on DioError catch (e) {
      showToastFail('Api buy post error dio$e');
    } catch (e) {
      showToastFail('Api buy post error$e');
    }
    return result;
  }

  @override
  Future<Post?> accomplished(String postId) async {
    Post? result;
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Map<String, dynamic> dataRequest = {
        "postId": postId,
        "status": PostStatus.ACCOMPLISHED
      };
      Response response = await Dio().put('${UrlApi.postController}/status',
          options: optionRequest, data: dataRequest);
      result = Post.fromJson(response.data['data']);
    } on DioError catch (e) {
      showToastFail('Api buy post error dio$e');
    } catch (e) {
      showToastFail('Api buy post error$e');
    }
    return result;
  }

  @override
  Future<Post?> delivered(String postId) async {
    Post? result;
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Map<String, dynamic> dataRequest = {
        "postId": postId,
        "status": PostStatus.DELIVERED
      };
      Response response = await Dio().put('${UrlApi.postController}/status',
          options: optionRequest, data: dataRequest);
      result = Post.fromJson(response.data['data']);
    } on DioError catch (e) {
      showToastFail('Api buy post error dio$e');
    } catch (e) {
      showToastFail('Api buy post error$e');
    }
    return result;
  }

  @override
  Future<Post?> failure(String postId) async {
    Post? result;
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Map<String, dynamic> dataRequest = {
        "postId": postId,
        "status": PostStatus.FAILURE
      };
      Response response = await Dio().put('${UrlApi.postController}/status',
          options: optionRequest, data: dataRequest);
      result = Post.fromJson(response.data['data']);
    } on DioError catch (e) {
      showToastFail('Api buy post error dio$e');
    } catch (e) {
      showToastFail('Api buy post error$e');
    }
    return result;
  }
  
  @override
  Future<List<Post>> getPostUserBoughtStatus(String status) async{
    List<Post> result = [];
    try {
      String token = await secureStorage.readSecureData('token');
      Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
      String userId = tokenDecode['id'];
      Options optionRequest = await OptionRequest.optionAuthorize();
      Response response = await Dio().get(
          '${UrlApi.postController}/userBought/$userId',
          options: optionRequest,
          queryParameters: {
            "status": status,
            "pageSize": 30,
          });
      result =
          (response.data['data'] as List).map((e) => Post.fromJson(e)).toList();
    } on DioError catch (e) {
      showToastFail('Api get status post$e');
    } catch (e) {
      showToastFail('Api get status post$e');
    }
    return result;
  }
  
  @override
  Future<Post?> inactive(String postId) async{
    Post? result;
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Map<String, dynamic> dataRequest = {
        "postId": postId,
        "status": PostStatus.INACTIVE
      };
      Response response = await Dio().put('${UrlApi.postController}/status',
          options: optionRequest, data: dataRequest);
      result = Post.fromJson(response.data['data']);
    } on DioError catch (e) {
      showToastFail('Api buy post error dio$e');
    } catch (e) {
      showToastFail('Api buy post error$e');
    }
    return result;
  }
}
