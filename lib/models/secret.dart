// To parse this JSON data, do
//
//     final secret = secretFromJson(jsonString);

import 'dart:convert';

Secret secretFromJson(String str) => Secret.fromJson(json.decode(str));

String secretToJson(Secret data) => json.encode(data.toJson());

class Secret {
  Secret({
    this.username,
    this.name,
    this.value,
    this.category,
    this.createdAt,
  });

  String username;
  String name;
  String value;
  String category;
  DateTime createdAt;

  factory Secret.fromJson(Map<String, dynamic> json) => Secret(
        username: json["username"],
        name: json["name"],
        value: json.containsKey('value') ? json['value'] : 'no-value',
        category: json["category"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "value": value,
        "category": category,
        "createdAt": createdAt.toIso8601String(),
      };
}
