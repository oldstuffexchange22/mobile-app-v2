import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/repository/implement/user_repository_implement.dart';
import 'package:old_stuff_exchange/view_model/service/service_storage.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  final SecureStorage secureStorage = SecureStorage();
  Future<void> getCurrentUser() async {
    String token = await secureStorage.readSecureData('token');
    if (token.isEmpty) {
      showToastFail('Không thể tải dữ liệu người dùng');
      return;
    }
    Map<String, dynamic> tokenDecode = Jwt.parseJwt(token);
    String userId = tokenDecode['id'];
    UserRepImp().getUserById(userId).then((value) => _currentUser = value);
    notifyListeners();
  }
}
