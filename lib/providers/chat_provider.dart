import 'package:flutter/material.dart';
import '../api/chat_api.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final ChatAPI chatAPI;
  List<Message> messages = [];

  ChatProvider(this.chatAPI);

  /// Envía un mensaje y lo agrega a la lista de mensajes en caso de éxito.
  Future<void> sendMessage(Message message) async {
    try {
      final response = await chatAPI.sendMessage(message);
      if (response != null && response.statusCode == 200) {
        messages.add(message);
        notifyListeners();
      } else {
        print("Error al enviar el mensaje: ${response?.statusMessage ?? 'Respuesta nula'}");
      }
    } catch (e) {
      print("Excepción al enviar mensaje: $e");
    }
  }

  /// Obtiene el historial de chat del servidor y actualiza la lista de mensajes.
  Future<void> getChatHistory(String userId) async {
    try {
      final response = await chatAPI.getChatHistory(userId);
      if (response != null && response.statusCode == 200) {
        messages = (response.data as List).map((msg) => Message.fromJson(msg)).toList();
        notifyListeners();
      } else {
        print("Error al obtener historial de chat: ${response?.statusMessage ?? 'Respuesta nula'}");
      }
    } catch (e) {
      print("Excepción al obtener historial de chat: $e");
    }
  }

  /// Limpia el historial de mensajes en el servidor y localmente.
  Future<void> clearChat(String conversationId) async {
    try {
      final response = await chatAPI.clearConversation(conversationId);
      if (response != null && response.statusCode == 200) {
        messages.clear(); // Limpiar la lista local de mensajes
        notifyListeners();
      } else {
        print("Error al limpiar la conversación: ${response?.statusMessage ?? 'Respuesta nula'}");
      }
    } catch (e) {
      print("Excepción al limpiar conversación: $e");
    }
  }
}
