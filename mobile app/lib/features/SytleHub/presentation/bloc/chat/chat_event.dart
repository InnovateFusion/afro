part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendRealTimeMessageEvent extends ChatEvent {
  final String message;

  const SendRealTimeMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveMessageEvent extends ChatEvent {
  final String message;

  const ReceiveMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class GetChatsEvent extends ChatEvent {
  final UserEntity? user;
  final String receiverId;
  const GetChatsEvent({
    required this.receiverId,
    this.user,
  });
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  final String receiverId;
  final String token;

  const DeleteChatEvent(
      {required this.chatId, required this.receiverId, required this.token});
}

class GetChatByIdEvent extends ChatEvent {
  final String chatId;
  final String token;

  const GetChatByIdEvent({required this.chatId, required this.token});
}

class SendMessageEvent extends ChatEvent {
  final types.TextMessage message;
  final int type;
  final String receiverId;
  final String token;

  const SendMessageEvent(
      {required this.message,
      required this.type,
      required this.receiverId,
      required this.token});
}

class SendImageMessageEvent extends ChatEvent {
  final types.ImageMessage message;
  final int type;
  final File logo;
  final String receiverId;
  final String token;

  const SendImageMessageEvent(
      {required this.message,
      required this.type,
      required this.logo,
      required this.receiverId,
      required this.token});
}

class GetChatParticipantsEvent extends ChatEvent {
  final String token;

  const GetChatParticipantsEvent({required this.token});
}

class SignalRStartEvent extends ChatEvent {}

class SignalRStopEvent extends ChatEvent {}

class SetCurrentUserEvent extends ChatEvent {
  final UserEntity? user;

  const SetCurrentUserEvent({this.user});
}

class ClearChatEvent extends ChatEvent {}

class GetChatsMoreEvent extends ChatEvent {
  final UserEntity? user;
  final String receiverId;
  const GetChatsMoreEvent({
    required this.receiverId,
    this.user,
  });
}

class RealTimeChatMessageDeletedEvent extends ChatEvent {
  final String message;

  const RealTimeChatMessageDeletedEvent({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class RealTimeChatMarkAsReadEvent extends ChatEvent {
  final String message;

  const RealTimeChatMarkAsReadEvent({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class MarkChatAsReadEvent extends ChatEvent {
  final String senderId;
  final String chatId;
  final String token;

  const MarkChatAsReadEvent(
      {required this.senderId, required this.chatId, required this.token});
}

class SearchUserEvent extends ChatEvent {
  final String query;

  const SearchUserEvent({required this.query});
}
