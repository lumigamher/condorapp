import 'package:dio/dio.dart';
import '../models/message.dart';
import 'api_client.dart';

class ChatAPI {
  final ApiClient apiClient;

  ChatAPI(this.apiClient);

  Future<Response> sendMessage(Message message) async {
    return await apiClient.dio.post('/chat/send', data: message.toJson());
  }

  Future<Response> getChatHistory(String userId) async {
    return await apiClient.dio.get('/chat/history', queryParameters: {'user_id': userId});
  }

  Future<Response> clearConversation(String conversationId) async {
    return await apiClient.dio.delete('/chat/clear/$conversationId');
  }
}
