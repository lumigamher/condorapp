// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_api.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthAPI authAPI;
  bool _isAuthenticated = false;
  String _token = '';

  AuthProvider(this.authAPI);

  bool get isAuthenticated => _isAuthenticated;
  String get token => _token;

  Future<void> login(User user) async {
    try {
      final response = await authAPI.login(user);
      if (response.statusCode == 200 && response.data['token'] != null) {
        _token = response.data['token'];
        _isAuthenticated = true;
        await saveToken(_token);
        notifyListeners();
      }
    } catch (e) {
      print("Error en login: $e");
    }
  }

  Future<void> signup(User user) async {
    try {
      final response = await authAPI.signup(user);
      if (response.statusCode == 200) {
        notifyListeners();
      }
    } catch (e) {
      print("Error en signup: $e");
    }
  }

  Future<void> logout() async {
    _token = '';
    _isAuthenticated = false;
    await removeToken();
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token') ?? '';
    _isAuthenticated = _token.isNotEmpty;
    notifyListeners();
  }
}
