import '../user/user_model.dart';
import '../../../domain/entities/chat/chat_user_with_last_message_entity.dart';

import 'chat_model.dart';

class ChatUserWithLastMessageModel extends ChatUserWithLastMessageEntity {
  const ChatUserWithLastMessageModel(
      {required super.lastMessage, required super.user});

  factory ChatUserWithLastMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatUserWithLastMessageModel(
      lastMessage: ChatModel.fromJson(json['lastMessage']),
      user: UserModel.fromJson(json['user']),
    );
  }
}
