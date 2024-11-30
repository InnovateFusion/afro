import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {

  final String id;
  final String message;
  final int type;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;
  final bool isRead;

  const ChatEntity({
    required this.id,
    required this.message,
    required this.type,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.isRead,
  });

  @override
  List<Object> get props => [id, message, type, senderId, receiverId, createdAt, isRead];

  ChatEntity copyWith({
    String? id,
    String? message,
    int? type,
    String? senderId,
    String? receiverId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      message: message ?? this.message,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

}
