import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/transaction.dart';
import 'package:old_stuff_exchange/repository/transaction_req.dart';
import 'package:old_stuff_exchange/utils/option_request.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class TransactionReqImp extends TransactionReq {
  final SecureStorage secureStorage = SecureStorage();
  @override
  Future<List<Transaction>> getTransactionsWithUser() async {
    late List<Transaction> result;
    try {
      String token = await secureStorage.readSecureData('token');
      Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
      String userId = tokenDecode['id'];
      Options requestOptions = await OptionRequest.optionAuthorize();
      Map<String, dynamic> queryRequest = {'page': 1, 'pageSize': 50};
      Response response = await Dio().get(
          '${UrlApi.transactionController}/user/$userId',
          options: requestOptions,
          queryParameters: queryRequest);
      result = (response.data['data'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList();
    } catch (e) {
      showToastFail('Transaction api error $e');
    }
    return result;
  }

  @override
  Future<List<Transaction>> getTransactionsWithWallet(String walletId) async {
    late List<Transaction> result;
    try {
      Options requestOptions = await OptionRequest.optionAuthorize();
      Response response = await Dio().get(
        '${UrlApi.transactionController}/wallet/$walletId',
        options: requestOptions,
      );
      result = (response.data['data'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList();
    } catch (e) {
      showToastFail('Transaction api error $e');
    }
    return result;
  }
}
