class LoginFirebaseRequest {
  LoginFirebaseRequest({this.token});
  String? token;

  factory LoginFirebaseRequest.fromJson(Map<String, dynamic> json) =>
      LoginFirebaseRequest(token: json['token']);
  Map<String, dynamic> toJson() => {'token': token};
}
