import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:old_stuff_exchange/config/constrant/wallet_type.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/apartment.dart';
import 'package:old_stuff_exchange/model/entity/transaction.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/model/entity/wallet.dart';
import 'package:old_stuff_exchange/model/request/user_update.dart';
import 'package:old_stuff_exchange/repository/implement/apartment_repository_implement.dart';
import 'package:old_stuff_exchange/repository/implement/deposit_req_imp.dart';
import 'package:old_stuff_exchange/repository/implement/transaction_req_imp.dart';
import 'package:old_stuff_exchange/repository/implement/user_repository_implement.dart';
import 'package:old_stuff_exchange/repository/implement/wallet_req_imp.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  set setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Apartment? _currentApartment;
  Apartment? get currentApartment => _currentApartment;

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
    String apartmentId = tokenDecode['apartmentId'];
    if (userId.isEmpty) {
      Timer(const Duration(microseconds: 4000), () {
        UserRepImp().getUserById(userId).then((value) => _currentUser = value);
      });
    } else {
      _currentUser = await UserRepImp().getUserById(userId);
      _currentApartment = await ApartmentReqImp().getById(apartmentId);
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

  Future<void> updateUser(
      BuildContext context, String column, String value) async {
    UserUpdate userUpdate = UserUpdate.fromUser(_currentUser!);
    context.loaderOverlay.show(
        widget: const CustomOverlay(
      content: 'Đang cập nhật ...',
    ));
    if (column == 'NAME') {
      userUpdate.name = value;
    } else if (column == 'PHONE') {
      userUpdate.phone = value;
    } else if (column == 'GENDER') {
      userUpdate.gender = value;
    } else if (column == 'IMAGE') {
      userUpdate.image = value;
    }
    _currentUser = await UserRepImp().updateUser(userUpdate);
    notifyListeners();
    showToastSuccess('Cập nhật thành công');
    context.loaderOverlay.hide();
  }

  Future<void> rechargeMoney(BuildContext context, double amount) async {
    context.loaderOverlay.show(
        widget: const CustomOverlay(
      content: 'Đang nạp tiền',
    ));
    await DepositReqImp().create('MOMO', 'RECHARGE MOMO : ${amount}00', amount);
    await getWalletOfUser();
    showToastSuccess('Nạp tiền thành công');
    notifyListeners();
    context.loaderOverlay.hide();
  }
}
