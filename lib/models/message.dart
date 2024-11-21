class Message {
  final String? id;
  final String content;
  final bool fromAI;
  final String conversationId;
  final DateTime? timestamp;

  Message({
    this.id,
    required this.content,
    required this.fromAI,
    required this.conversationId,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'fromAI': fromAI,
      'conversationId': conversationId,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString(),
      content: json['content'] ?? '',
      fromAI: json['fromAI'] ?? false,
      conversationId: json['conversationId'] ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }

  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    
    if (timestamp is List) {
      // Si es una lista [2024, 11, 20, 18, 58, 9, 31466700]
      return DateTime(
        timestamp[0], // año
        timestamp[1], // mes
        timestamp[2], // día
        timestamp[3], // hora
        timestamp[4], // minuto
        timestamp[5], // segundo
        timestamp[6] ~/ 1000000, // nanosegundos a milisegundos
      );
    } else if (timestamp is String) {
      // Si es una cadena ISO
      return DateTime.tryParse(timestamp);
    }
    
    return null;
  }
}