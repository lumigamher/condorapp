// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import '../api/chat_api.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final ChatAPI chatAPI;
  List<Message> messages = [];

  ChatProvider(this.chatAPI);

  Future<void> sendMessage(Message message) async {
    try {
      final response = await chatAPI.sendMessage(message);
      if (response.statusCode == 200) {
        messages.add(message);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getChatHistory(String userId) async {
    try {
      final response = await chatAPI.getChatHistory(userId);
      if (response.statusCode == 200) {
        messages = (response.data as List).map((msg) => Message.fromJson(msg)).toList();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
