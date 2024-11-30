import '../../../domain/entities/chat/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.message,
    required super.type,
    required super.senderId,
    required super.receiverId,
    required super.createdAt,
    required super.isRead,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      type: json['type'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type,
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }
}
