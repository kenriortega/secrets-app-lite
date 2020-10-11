// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
    this.username,
    this.fullName,
    this.role,
    this.createdAt,
  });

  String username;
  String fullName;
  String role;
  DateTime createdAt;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        username: json["username"],
        fullName: json["fullName"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "fullName": fullName,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
      };
}
