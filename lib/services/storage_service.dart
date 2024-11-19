import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String TOKEN_KEY = 'auth_token';
  
  static final StorageService _instance = StorageService._internal();
  
  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}