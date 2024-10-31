// lib/models/message.dart

class Message {
  final String content;
  final bool fromAI;
  final String conversationId;

  Message({required this.content, required this.fromAI, required this.conversationId});

  Map<String, dynamic> toJson() => {
    'content': content,
    'fromAI': fromAI,
    'conversationId': conversationId,
  };

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      fromAI: json['fromAI'],
      conversationId: json['conversationId'],
    );
  }
}
