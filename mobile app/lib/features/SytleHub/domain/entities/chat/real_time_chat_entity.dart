import 'package:equatable/equatable.dart';

class RealTimeChatEntity extends Equatable {
  final String id;
  final String message;
  final int type;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String receiverName;
  final String senderAvatar;
  final String receiverAvatar;
  final DateTime createdAt;
  final bool isRead;

  const RealTimeChatEntity({
    required this.id,
    required this.message,
    required this.type,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.senderAvatar,
    required this.receiverAvatar,
    required this.createdAt,
    required this.isRead,
  });

  @override
  List<Object> get props => [
        id,
        message,
        type,
        senderId,
        receiverId,
        senderName,
        receiverName,
        senderAvatar,
        receiverAvatar,
        createdAt,
        isRead
      ];

  RealTimeChatEntity copyWith({
    String? id,
    String? message,
    int? type,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? receiverName,
    String? senderAvatar,
    String? receiverAvatar,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return RealTimeChatEntity(
      id: id ?? this.id,
      message: message ?? this.message,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      receiverAvatar: receiverAvatar ?? this.receiverAvatar,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
