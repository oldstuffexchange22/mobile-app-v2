import 'package:dio/dio.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/wallet.dart';
import 'package:old_stuff_exchange/repository/wallet_repository.dart';
import 'package:old_stuff_exchange/utils/option_request.dart';
import 'package:old_stuff_exchange/view_model/url_api/url_api.dart';

class WalletReqImp implements WalletReq {
  @override
  Future<List<Wallet>> getWalletsByUserId(String userId) async {
    List<Wallet> result = [];
    try {
      Options optionRequest = await OptionRequest.optionAuthorize();
      Response response = await Dio().get(
          '${UrlApi.walletController}/user/$userId',
          options: optionRequest);
      result = (response.data['data'] as List)
          .map((e) => Wallet.fromJson(e))
          .toList();
    } on DioError catch (ex) {
      showToastFail(ex.toString());
    } catch (ex) {
      showToastFail(ex.toString());
    }
    return result;
  }
}
