import 'package:equatable/equatable.dart';
import 'chat_entity.dart';
import '../user/user_entity.dart';

class ChatUserWithLastMessageEntity extends Equatable {
  final ChatEntity lastMessage;
  final UserEntity user;

  const ChatUserWithLastMessageEntity({
    required this.lastMessage,
    required this.user,
  });

  @override
  List<Object> get props => [lastMessage, user];

  ChatUserWithLastMessageEntity copyWith({
    ChatEntity? lastMessage,
    UserEntity? user,
  }) {
    return ChatUserWithLastMessageEntity(
      lastMessage: lastMessage ?? this.lastMessage,
      user: user ?? this.user,
    );
  }
}
