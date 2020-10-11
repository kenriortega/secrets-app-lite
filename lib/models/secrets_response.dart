// To parse this JSON data, do
//
//     final secretResponse = secretResponseFromJson(jsonString);

import 'dart:convert';

import 'package:mntd_pass_lite/models/secret.dart';

SecretResponse secretResponseFromJson(String str) =>
    SecretResponse.fromJson(json.decode(str));

String secretResponseToJson(SecretResponse data) => json.encode(data.toJson());

class SecretResponse {
  SecretResponse({
    this.count,
    this.data,
  });

  int count;
  List<Secret> data;

  factory SecretResponse.fromJson(Map<String, dynamic> json) => SecretResponse(
        count: json["count"],
        data: List<Secret>.from(json["data"].map((x) => Secret.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
