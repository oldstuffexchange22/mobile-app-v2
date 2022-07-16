import 'dart:io';

import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/category.dart';
import 'package:old_stuff_exchange/repository/category_repository.dart';
import 'package:old_stuff_exchange/utils/option_request.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class CategoryReqImp implements CategoryReq {
  @override
  Future<List<Category>> getAll() async {
    List<Category> result = [];
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Map<String, dynamic> params = {'page': 1, 'pageSize': 100};
      Response response = await Dio().get(UrlApi.categoryController,
          options: optionRequest, queryParameters: params);
      result = (response.data['data'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    } on DioError catch (e) {
      showToastFail('Can\'t load categories $e');
    } catch (e) {
      showToastFail('Can\'t load categories $e');
    }
    return result;
  }
}
