import 'package:dio/dio.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../models/message.dart';
import 'api_client.dart';
import 'dart:convert';

class ChatAPI {
  final ApiClient _apiClient;
  StompClient? _stompClient;
  bool isConnected = false;

  // Callbacks
  Function(Message)? onMessageReceived;
  Function(bool)? onConnectionStateChange;
  Function(String, bool)? onTypingStatusReceived;

  ChatAPI(this._apiClient);

  Future<void> connect(String token) async {
    final wsUrl = _apiClient.baseUrl.replaceFirst('http', 'ws');
    
    _stompClient = StompClient(
      config: StompConfig(
        url: '$wsUrl/ws',
        onConnect: (frame) {
          print('Conectado a WebSocket');
          isConnected = true;
          onConnectionStateChange?.call(true);
          _subscribeToTopics();
        },
        onDisconnect: (frame) {
          print('Desconectado de WebSocket');
          isConnected = false;
          onConnectionStateChange?.call(false);
        },
        onWebSocketError: (error) {
          print('Error WebSocket: $error');
          isConnected = false;
          onConnectionStateChange?.call(false);
        },
        onStompError: (frame) {
          print('Error STOMP: ${frame.body}');
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer $token'
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $token'
        },
      ),
    );

    _stompClient?.activate();
  }

  void _subscribeToTopics() {
    // Suscripción a mensajes personales
    _stompClient?.subscribe(
      destination: '/user/queue/messages',
      callback: (frame) {
        if (frame.body != null) {
          try {
            final message = Message.fromJson(
              Map<String, dynamic>.from(json.decode(frame.body!))
            );
            onMessageReceived?.call(message);
          } catch (e) {
            print('Error al procesar mensaje WebSocket: $e');
          }
        }
      },
    );

    // Suscripción a eventos de typing
    _stompClient?.subscribe(
      destination: '/user/queue/typing',
      callback: (frame) {
        if (frame.body != null) {
          try {
            final data = json.decode(frame.body!);
            onTypingStatusReceived?.call(
              data['userId'],
              data['typing']
            );
          } catch (e) {
            print('Error al procesar evento typing: $e');
          }
        }
      },
    );
  }

  Future<Map<String, dynamic>?> sendMessage(Message message) async {
    try {
      print('Enviando mensaje: ${message.toJson()}');

      if (_stompClient?.connected == true) {
        _stompClient?.send(
          destination: '/app/chat.send',
          body: json.encode(message.toJson()),
        );
        // Para WebSocket, esperamos la respuesta a través del callback onMessageReceived
        return {'success': true};
      } else {
        // Fallback a HTTP con la configuración mejorada
        final response = await _apiClient.dio.post(
          '/api/chat/send',
          data: message.toJson(),
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json;charset=UTF-8',
            },
            responseType: ResponseType.json,
            validateStatus: (status) => status! < 500,
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
          ),
        );

        print('Respuesta HTTP recibida: ${response.data}');

        if (response.statusCode == 200) {
          return response.data as Map<String, dynamic>;
        } else {
          print('Error: ${response.statusCode} - ${response.data}');
          return null;
        }
      }
    } catch (e) {
      print('Error enviando mensaje: $e');
      return null;
    }
  }

  Future<Response?> getChatHistory() async {
    try {
      final response = await _apiClient.dio.get(
        '/api/chat/history',
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=UTF-8',
          },
        ),
      );
      print('Historial recibido: ${response.data}');
      return response;
    } catch (e) {
      print('Error obteniendo historial: $e');
      return null;
    }
  }

  Future<String?> startNewConversation() async {
    try {
      final response = await _apiClient.dio.post(
        '/api/chat/conversation',  // Cambiado de conversation/new a conversation
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=UTF-8',
          },
        ),
      );
      
      print('Nueva conversación respuesta: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null) {
        return response.data['conversationId'];
      }
      return null;
    } catch (e) {
      print('Error iniciando conversación: $e');
      return null;
    }
  }

  Future<bool> clearConversation(String conversationId) async {
    try {
      final response = await _apiClient.dio.delete(
        '/api/chat/conversation/$conversationId',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json;charset=UTF-8',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error limpiando conversación: $e');
      return false;
    }
  }

  void sendTypingStatus(bool isTyping) {
    if (_stompClient?.connected == true) {
      try {
        _stompClient?.send(
          destination: '/app/chat.typing',
          body: json.encode({'typing': isTyping}),
        );
      } catch (e) {
        print('Error enviando estado de typing: $e');
      }
    }
  }

  void disconnect() {
    try {
      _stompClient?.deactivate();
      isConnected = false;
      onConnectionStateChange?.call(false);
    } catch (e) {
      print('Error al desconectar: $e');
    }
  }
}