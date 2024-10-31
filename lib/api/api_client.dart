import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'https://api.example.com/api'; // Cambia por la URL de tu API
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  ApiClient() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Si tienes un token, agrégalo a los encabezados
        String token = getToken(); // Crea una función para obtener el token dinámicamente
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (e.response != null && e.response?.statusCode == 401) {
          // Maneja errores de autenticación
          print("Error de autenticación: ${e.response?.statusCode}");
        } else {
          // Otros errores
          print("Error: ${e.message}");
        }
        return handler.next(e);
      },
    ));
  }

  // Métodos para realizar solicitudes HTTP comunes
  Future<Response> getRequest(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      return await dio.get(endpoint, queryParameters: queryParams);
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      return await dio.post(endpoint, data: data);
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Response> putRequest(String endpoint, dynamic data) async {
    try {
      return await dio.put(endpoint, data: data);
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  Future<Response> deleteRequest(String endpoint) async {
    try {
      return await dio.delete(endpoint);
    } on DioException catch (e) {
      return handleError(e);
    }
  }

  // Método auxiliar para manejar errores
  Response handleError(DioException e) {
    if (e.response != null) {
      print("Error en la solicitud: ${e.response?.statusCode} - ${e.response?.statusMessage}");
      return e.response!;
    } else {
      print("Error de conexión o solicitud: ${e.message}");
      throw Exception("Error de conexión o solicitud");
    }
  }

  // Ejemplo de función para obtener el token
  String getToken() {
    // Aquí deberías obtener el token desde un almacenamiento seguro, como SharedPreferences o SecureStorage
    return "tu_token";
  }
}
