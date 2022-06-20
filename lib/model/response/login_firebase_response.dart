class LoginFirebaseResponse {
  LoginFirebaseResponse({this.token});
  String? token;

  factory LoginFirebaseResponse.fromJson(Map<String, dynamic> json) =>
      LoginFirebaseResponse(token: json['token']);
  Map<String, dynamic> toJson() => {'token': token};
}
