import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/model/request/user_update.dart';

abstract class UserRepository {
  Future<User> getUserById(String id);
  Future<User> updateAddress(String userId, String buildingId);
  Future<User> updateUser(UserUpdate user);
}
