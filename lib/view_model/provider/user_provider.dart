import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:old_stuff_exchange/config/constrant/wallet_type.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/model/entity/wallet.dart';
import 'package:old_stuff_exchange/repository/implement/user_repository_implement.dart';
import 'package:old_stuff_exchange/repository/implement/wallet_req_imp.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  Wallet? _defaultWallet;
  Wallet? _promotionWallet;
  Wallet? get defaultWallet => _defaultWallet;
  Wallet? get promotionWallet => _promotionWallet;

  final SecureStorage secureStorage = SecureStorage();
  Future<void> getCurrentUser() async {
    String token = (await secureStorage.readSecureData('token')) ?? '';
    if (token.isEmpty) {
      showToastFail('Không thể tải dữ liệu người dùng');
      return;
    }
    Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
    String userId = tokenDecode['id'];
    if (userId.isEmpty) {
      Timer(const Duration(microseconds: 4000), () {
        UserRepImp().getUserById(userId).then((value) => _currentUser = value);
      });
    } else {
      _currentUser = await UserRepImp().getUserById(userId);
    }
    notifyListeners();
  }

  Future<void> getWalletOfUser() async {
    String token = (await secureStorage.readSecureData('token')) ?? '';
    Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
    String userId = tokenDecode['id'];
    List<Wallet> wallets = await WalletReqImp().getWalletsByUserId(userId);
    _defaultWallet = wallets.firstWhere((w) => w.type == WalletType.basic);
    _promotionWallet =
        wallets.firstWhere((w) => w.type == WalletType.promotion);
    notifyListeners();
  }

  Future<void> updateUserAddress(String buildingId) async {
    String userId = _currentUser?.id ?? '';
    if (userId.isEmpty) {
      showToastFail('User id bị trống');
      return;
    }
    _currentUser = await UserRepImp().updateAddress(userId, buildingId);
    notifyListeners();
  }
}
