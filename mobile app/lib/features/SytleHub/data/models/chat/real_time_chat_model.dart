import '../../../domain/entities/chat/real_time_chat_entity.dart';

class RealTimeChatModel extends RealTimeChatEntity {
  const RealTimeChatModel(
      {required super.id,
      required super.message,
      required super.type,
      required super.senderId,
      required super.receiverId,
      required super.senderName,
      required super.receiverName,
      required super.senderAvatar,
      required super.receiverAvatar,
      required super.createdAt,
      required super.isRead});

  factory RealTimeChatModel.fromJson(Map<String, dynamic> json) {
    return RealTimeChatModel(
      id: json['id'],
      message: json['message'],
      type: json['type'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      senderName: json['senderName'],
      receiverName: json['receiverName'],
      senderAvatar: json['senderAvatar'],
      receiverAvatar: json['receiverAvatar'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'],
    );
  }
}
