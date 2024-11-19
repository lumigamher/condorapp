import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  late Dio dio;
  
  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8081',  // Quitamos /api de aquí
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status! < 500;  // Permite códigos 4xx para manejarlos manualmente
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('Realizando petición a: ${options.uri}');
          final token = await getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print('Error en la petición:');
          print('URL: ${e.requestOptions.uri}');
          print('Método: ${e.requestOptions.method}');
          print('Status code: ${e.response?.statusCode}');
          print('Response: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  get baseUrl => null;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}