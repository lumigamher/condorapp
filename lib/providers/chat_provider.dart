import 'package:flutter/material.dart';
import '../api/chat_api.dart';
import '../models/message.dart';
import '../services/storage_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatAPI chatAPI;
  final StorageService _storage = StorageService();
  List<Message> messages = [];
  String? currentConversationId;
  bool isLoading = false;
  String? error;
  bool isConnected = false;
  Map<String, bool> typingUsers = {};

  ChatProvider(this.chatAPI) {
    _initWebSocket();
  }

  void updateFrom(ChatProvider? previous) {
    if (previous != null) {
      messages = List.from(previous.messages);
      currentConversationId = previous.currentConversationId;
      isLoading = previous.isLoading;
      error = previous.error;
      isConnected = previous.isConnected;
      typingUsers = Map.from(previous.typingUsers);
      notifyListeners();
    }
  }

  Future<void> _initWebSocket() async {
    chatAPI.onMessageReceived = _handleMessage;
    chatAPI.onConnectionStateChange = _handleConnectionState;
    chatAPI.onTypingStatusReceived = _handleTypingStatus;
    
    final token = await _storage.getToken();
    if (token != null) {
      try {
        await chatAPI.connect(token);
      } catch (e) {
        error = "Error al conectar: ${e.toString()}";
        print('Error en la inicialización del WebSocket: $e');
      }
    } else {
      error = "No hay token de autenticación disponible";
      print('No se encontró token para inicializar WebSocket');
    }
    notifyListeners();
  }

  void _handleMessage(Message message) {
    try {
      print('Mensaje recibido: ${message.content}');
      messages.add(message);
      notifyListeners();
    } catch (e) {
      print('Error al manejar mensaje recibido: $e');
      error = "Error al procesar mensaje recibido";
      notifyListeners();
    }
  }

  void _handleConnectionState(bool connected) {
    print('Estado de conexión cambiado: $connected');
    isConnected = connected;
    if (!connected) {
      error = "Conexión perdida. Reconectando...";
      _reconnect();
    } else {
      error = null;
    }
    notifyListeners();
  }

  Future<void> _reconnect() async {
    try {
      final token = await _storage.getToken();
      if (token != null) {
        await chatAPI.connect(token);
      }
    } catch (e) {
      print('Error en reconexión: $e');
    }
  }

  void _handleTypingStatus(String userId, bool isTyping) {
    typingUsers[userId] = isTyping;
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) {
      print('Mensaje vacío ignorado');
      return;
    }

    Message? userMessage;
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      if (currentConversationId == null) {
        print('Iniciando nueva conversación antes de enviar mensaje');
        await startNewConversation();
        
        if (currentConversationId == null) {
          throw Exception("No se pudo iniciar una nueva conversación");
        }
      }

      userMessage = Message(
        content: content,
        fromAI: false,
        conversationId: currentConversationId!,
      );

      print('Enviando mensaje: ${userMessage.content}');
      messages.add(userMessage);
      notifyListeners();

      final response = await chatAPI.sendMessage(userMessage);
      
      if (response != null) {
        print('Respuesta recibida del servidor');
        if (response['aiMessage'] != null) {
          final aiMessage = Message.fromJson(response['aiMessage']);
          messages.add(aiMessage);
          error = null;
        } else {
          throw Exception("Respuesta del servidor no contiene mensaje AI");
        }
      } else {
        throw Exception("No se recibió respuesta del servidor");
      }
    } catch (e) {
      error = e.toString();
      print('Error al enviar mensaje: $e');
      if (userMessage != null && messages.isNotEmpty) {
        // Solo remover si el mensaje existe en la lista
        if (messages.contains(userMessage)) {
          messages.remove(userMessage);
        }
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getChatHistory() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      print('Obteniendo historial de chat...');
      final response = await chatAPI.getChatHistory();
      
      if (response != null && response.statusCode == 200) {
        final List<dynamic> historicalMessages = response.data as List;
        messages = historicalMessages
            .map((msg) => Message.fromJson(msg))
            .toList();
        
        print('Historial cargado: ${messages.length} mensajes');
        
        if (messages.isNotEmpty) {
          currentConversationId = messages.last.conversationId;
          print('Conversación actual: $currentConversationId');
        }
        error = null;
      } else {
        error = "Error al cargar el historial";
        print('Error en la respuesta del historial: ${response?.statusCode}');
      }
    } catch (e) {
      error = "Error obteniendo historial: ${e.toString()}";
      print('Error al obtener historial: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startNewConversation() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      print('Iniciando nueva conversación...');
      final newConversationId = await chatAPI.startNewConversation();
      
      if (newConversationId != null) {
        currentConversationId = newConversationId;
        messages.clear();
        print('Nueva conversación iniciada: $currentConversationId');
        error = null;
      } else {
        throw Exception("No se pudo obtener ID de conversación");
      }
    } catch (e) {
      error = "Error al crear conversación: ${e.toString()}";
      print('Error al iniciar conversación: $e');
      currentConversationId = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCurrentConversation() async {
    if (currentConversationId == null) {
      print('No hay conversación activa para limpiar');
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      print('Limpiando conversación: $currentConversationId');
      final success = await chatAPI.clearConversation(currentConversationId!);
      
      if (success) {
        messages.clear();
        print('Conversación limpiada exitosamente');
        error = null;
      } else {
        error = "Error al limpiar la conversación";
        print('Error: No se pudo limpiar la conversación');
      }
    } catch (e) {
      error = "Error al limpiar: ${e.toString()}";
      print('Error al limpiar conversación: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void sendTypingStatus(bool isTyping) {
    if (isConnected && currentConversationId != null) {
      try {
        chatAPI.sendTypingStatus(isTyping);
        print('Estado de typing enviado: $isTyping');
      } catch (e) {
        print('Error al enviar estado de typing: $e');
      }
    }
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<void> reconnect() async {
    try {
      print('Intentando reconexión...');
      await _initWebSocket();
    } catch (e) {
      print('Error en reconexión manual: $e');
      error = "Error al reconectar: ${e.toString()}";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print('Disposando ChatProvider');
    chatAPI.disconnect();
    super.dispose();
  }

  // Métodos de utilidad para el estado
  bool get isReady => isConnected && !isLoading;
  bool get hasMessages => messages.isNotEmpty;
  bool get hasError => error != null;
  bool get isTyping => typingUsers.values.any((typing) => typing);
  
  // Método para obtener el estado actual (útil para debugging)
  Map<String, dynamic> getState() {
    return {
      'isConnected': isConnected,
      'isLoading': isLoading,
      'hasError': hasError,
      'error': error,
      'messageCount': messages.length,
      'currentConversationId': currentConversationId,
      'typingUsersCount': typingUsers.length,
    };
  }
}