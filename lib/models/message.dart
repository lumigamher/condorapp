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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id']?.toString(),
      content: json['content'],
      fromAI: json['fromAI'] ?? false,
      conversationId: json['conversationId'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'fromAI': fromAI,
      'conversationId': conversationId,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}