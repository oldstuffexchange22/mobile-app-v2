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
      required this.role,
      required this.buildingId});
  String id;
  String userName;
  String fullName;
  String status;
  String phone;
  String gender;
  String email;
  String imagesUrl;
  Role role;
  String buildingId;

  factory User.fromJon(Map<String, dynamic> json) => User(
      id: json['id'],
      userName: json['userName'],
      fullName: json['fullName'],
      status: json['status'],
      phone: json['phone'],
      gender: json['gender'],
      email: json['email'],
      imagesUrl: json['imagesUrl'],
      role: Role.fromJson(json['role']),
      buildingId: json['buildingId']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'fullName': fullName,
        'status': status,
        'phone': phone,
        'gender': gender,
        'email': email,
        'imagesUrl': imagesUrl,
        'role': role.toJson(),
        'buildingId': buildingId
      };
}
