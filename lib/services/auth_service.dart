import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/models/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  LoginResponse user;
  bool _autenticando = false;
  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }

  final _storage = new FlutterSecureStorage();

  // getter del token estaticos
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<String> getUsername() async {
    final _storage = new FlutterSecureStorage();
    final username = await _storage.read(key: 'username');
    return username;
  }

  Future<bool> login(String username, String password) async {
    this.autenticando = true;
    final data = {'username': username, 'password': password};
    final resp = await http.post(
      '${Environment.apiUrl}/auth',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse;
      await this._guardarToken(loginResponse.token);
      await this._guardarUser(username);
      await this._guardarPass(password);
      return true;
    } else {
      return false;
    }
  }

  Future register(String username, String fullName, String password) async {
    this.autenticando = true;
    final data = {
      'username': username,
      'fullName': fullName,
      'password': password
    };
    final resp = await http.post(
      '${Environment.apiUrl}/users',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    this.autenticando = false;

    if (resp.statusCode == 201) {
      return true;
    } else {
      final respBodyError = jsonDecode(resp.body);
      return respBodyError['message'];
    }
  }

  Future<bool> isLoggedIn() async {
    final data = {
      'username': await this._storage.read(key: 'username'),
      'password': await this._storage.read(key: 'password')
    };
    final resp = await http.post(
      '${Environment.apiUrl}/auth',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse;
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _guardarUser(String username) async {
    return await _storage.write(key: 'username', value: username);
  }

  Future _guardarPass(String password) async {
    return await _storage.write(key: 'password', value: password);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'username');
    await _storage.delete(key: 'password');
  }
}
