import 'package:old_stuff_exchange/model/entity/wallet.dart';

abstract class WalletReq {
  Future<List<Wallet>> getWalletsByUserId(String userId);
}
