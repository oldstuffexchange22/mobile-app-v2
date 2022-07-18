import 'package:old_stuff_exchange/model/entity/building.dart';

import 'role.dart';

class User {
  User(
      {required this.id,
      required this.userName,
      required this.fullName,
      required this.status,
      required this.phone,
      required this.gender,
      required this.email,
      required this.imagesUrl,
      this.role,
      this.building});
  String id;
  String userName;
  String fullName;
  String status;
  String phone;
  String gender;
  String email;
  String imagesUrl;
  Role? role;
  Building? building;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      userName: json['userName'] ?? '',
      fullName: json['fullName'] ?? '',
      status: json['status'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      imagesUrl: json['imageUrl'] ?? '',
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      building: json['building'] == null
          ? null
          : Building.fromJson(json['building']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'fullName': fullName,
        'status': status,
        'phone': phone,
        'gender': gender,
        'email': email,
        'imageUrl': imagesUrl,
      };
}
