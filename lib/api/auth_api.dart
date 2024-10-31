import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthAPI {
  final ApiClient apiClient;

  AuthAPI(this.apiClient);

  Future<Response> login(User user) async {
    return await apiClient.dio.post('/auth/login', data: user.toJson());
  }

  Future<Response> signup(User user) async {
    return await apiClient.dio.post('/auth/signup', data: user.toJson());
  }
}
