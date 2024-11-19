import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthAPI {
  final ApiClient _apiClient;

  AuthAPI(this._apiClient);

  Future<Response> login(User user) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/auth/login', // Asegúrate de que incluya '/api' al inicio
        data: user.toJson(),
      );
      return response;
    } catch (e) {
      print("Error en AuthAPI.login: $e");
      rethrow;
    }
  }

  Future<Response> signup(User user) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/auth/signup', // Asegúrate de que incluya '/api' al inicio
        data: user.toJson(),
      );
      return response;
    } catch (e) {
      print("Error en AuthAPI.signup: $e");
      rethrow;
    }
  }
}