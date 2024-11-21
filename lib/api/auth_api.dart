import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthAPI {
  final ApiClient _apiClient;

  AuthAPI(this._apiClient);

  Future<Response> signup(User user) async {
    try {
      print('Enviando datos de registro: ${user.toJson()}');
      
      final response = await _apiClient.dio.post(
        '/api/auth/signup',
        data: user.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print('Respuesta del servidor: ${response.data}');
      return response;
      
    } on DioException catch (e) {
      print('Error en AuthAPI.signup: $e');
      print('Response data: ${e.response?.data}');
      rethrow;
    }
  }

  Future<Response> login(User user) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/auth/login',
        data: user.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      
      print('Respuesta de login: ${response.data}');
      return response;
      
    } on DioException catch (e) {
      print('Error en AuthAPI.login: $e');
      print('Response data: ${e.response?.data}');
      rethrow;
    }
  }
}