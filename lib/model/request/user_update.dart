import 'package:old_stuff_exchange/model/entity/user.dart';

class UserUpdate {
  UserUpdate(
      {required this.id,
      required this.name,
      required this.email,
      required this.image,
      required this.buildingId,
      required this.status,
      required this.roleId,
      required this.phone,
      required this.gender});
  String id;
  String name;
  String email;
  String image;
  String buildingId;
  String status;
  String roleId;
  String phone;
  String gender;

  factory UserUpdate.fromUser(User user) => UserUpdate(
      id: user.id,
      name: user.fullName,
      email: user.email,
      image: user.imagesUrl,
      buildingId: user.building?.id ?? '',
      status: user.status,
      roleId: user.role?.id ?? '',
      phone: user.phone,
      gender: user.gender);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,    
        "buildingId": buildingId,
        "status": status,
        "roleId": roleId,
        "phone": phone,
        "gender": gender
      };
}
