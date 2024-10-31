import 'package:dio/dio.dart';
import '../models/message.dart';
import 'api_client.dart';

class ChatAPI {
  final ApiClient apiClient;

  ChatAPI(this.apiClient);

  /// Envía un mensaje al servidor.
  Future<Response?> sendMessage(Message message) async {
    try {
      final response = await apiClient.dio.post('/chat/send', data: message.toJson());
      return response;
    } on DioError catch (e) {
      print("Error al enviar mensaje: ${e.message}");
      return null;  // Retorna null en caso de error
    }
  }

  /// Obtiene el historial de chat para un usuario específico.
  Future<Response?> getChatHistory(String userId) async {
    try {
      final response = await apiClient.dio.get('/chat/history', queryParameters: {'user_id': userId});
      return response;
    } on DioError catch (e) {
      print("Error al obtener historial de chat: ${e.message}");
      return null;  // Retorna null en caso de error
    }
  }

  /// Borra una conversación específica.
  Future<Response?> clearConversation(String conversationId) async {
    try {
      final response = await apiClient.dio.delete('/chat/clear/$conversationId');
      return response;
    } on DioError catch (e) {
      print("Error al borrar la conversación: ${e.message}");
      return null;  // Retorna null en caso de error
    }
  }
}
