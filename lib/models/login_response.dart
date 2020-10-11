// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.username,
    this.fullName,
    this.role,
    this.token,
    this.createdAt,
  });

  String username;
  String fullName;
  String role;
  String token;
  DateTime createdAt;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        username: json["username"],
        fullName: json["fullName"],
        role: json["role"],
        token: json["token"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "fullName": fullName,
        "role": role,
        "token": token,
        "createdAt": createdAt.toIso8601String(),
      };
}
