import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/models/secret.dart';
import 'package:http/http.dart' as http;
import 'package:mntd_pass_lite/models/secrets_response.dart';

import 'auth_service.dart';

class SecretService with ChangeNotifier {
  Secret scretDetail;
  Future<List<Secret>> getSecrets() async {
    try {
      final token = await AuthService.getToken();
      final username = await AuthService.getUsername();
      final resp = await http.get(
        '${Environment.apiUrl}/secrets/$username',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      final secretResponse = secretResponseFromJson(resp.body);
      return secretResponse.data;
    } catch (e) {
      return [];
    }
  }

  Future addSecret(
    String username,
    String name,
    String value,
    String category,
  ) async {
    final token = await AuthService.getToken();
    final data = {
      'username': username,
      'name': name,
      'value': value,
      'category': category,
    };
    final resp = await http.post(
      '${Environment.apiUrl}/secrets',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 201) {
      return true;
    } else {
      final respBodyError = jsonDecode(resp.body);
      return respBodyError['message'];
    }
  }

  Future deleteSecret(
    String username,
    String nameSecret,
  ) async {
    final token = await AuthService.getToken();

    final resp = await http.delete(
      '${Environment.apiUrl}/secrets/$username/$nameSecret',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (resp.statusCode == 200) {
      return true;
    } else {
      final respBodyError = jsonDecode(resp.body);
      return respBodyError['message'];
    }
  }

  Future getSecret(
    String username,
    String nameSecret,
  ) async {
    final token = await AuthService.getToken();

    final resp = await http.get(
      '${Environment.apiUrl}/secrets/$username/$nameSecret',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (resp.statusCode == 200) {
      final respBodySuccess = secretFromJson(resp.body);
      this.scretDetail = respBodySuccess;
      return this.scretDetail;
    } else {
      final respBodyError = jsonDecode(resp.body);
      return respBodyError['message'];
    }
  }

  Future updateSecret(String username, String nameSecret, String value) async {
    final token = await AuthService.getToken();
    final data = {
      'value': value,
    };
    final resp = await http.put(
      '${Environment.apiUrl}/secrets/$username/$nameSecret',
      body: jsonEncode(data),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      return true;
    } else {
      final respBodyError = jsonDecode(resp.body);
      return respBodyError['message'];
    }
  }
}
