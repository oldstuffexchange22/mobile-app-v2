import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/deposit.dart';
import 'package:old_stuff_exchange/repository/deposit_repository.dart';
import 'package:old_stuff_exchange/utils/option_request.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class DepositReqImp extends DepositReq {
  final SecureStorage secureStorage = SecureStorage();
  @override
  Future<Deposit> create(
      String walletElectricName, String description, double amount) async {
    late Deposit result;
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      String userId = await secureStorage.getUserId();
      Map<String, dynamic> dataRequest = {
        'walletElectricName': walletElectricName,
        'description': description,
        'amount': amount,
        'userId': userId
      };
      Response response = await Dio().post(UrlApi.depositController,
          options: optionRequest, data: dataRequest);
      result = Deposit.fromJson(response.data['data']);
    } catch (e) {
      showToastFail('Create deposit error $e');
    }
    return result;
  }
}
