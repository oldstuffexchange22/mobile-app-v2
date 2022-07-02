import 'package:old_stuff_exchange/model/entity/user.dart';

abstract class UserRepository {
  Future<User> getUserById(String id);
  Future<User> updateAddress(String userId, String buildingId);
}
