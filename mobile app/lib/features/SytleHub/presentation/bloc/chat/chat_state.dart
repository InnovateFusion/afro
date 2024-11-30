part of 'chat_bloc.dart';

enum RealTimeMessageStatus {
  intial,
  connected,
  connecting,
  disconnected,
  sent,
  received,
  error,
  sending
}

enum SendMessageStatus { intial, sent, received, error, sending }

enum GetChatsStatus { initial, loading, success, failure }

enum GetChatsMoreStatus { initial, loading, success, failure, noMore }

enum GetChatStatus { initial, loading, success, failure }

enum DeleteChatStatus { initial, loading, success, failure }

enum GetChatByIdStatus { initial, loading, success, failure }

enum MarkChatAsReadStatus { initial, loading, success, failure }

enum GetChatParticipantsStatus { initial, loading, loadMore, success, failure }

enum SearchUserStatus { initial, loading, success, failure, noMore, loadMore }

class ChatState extends Equatable {
  final Map<String, ChatParticipantEntity> chatParticipants;
  final RealTimeMessageStatus status;
  final SendMessageStatus sendMessageStatus;
  final MarkChatAsReadStatus markChatAsReadStatus;
  final GetChatByIdStatus getChatByIdStatus;
  final GetChatStatus getChatStatus;
  final DeleteChatStatus deleteChatStatus;
  final GetChatsStatus getChatsStatus;
  final GetChatsMoreStatus getChatsMoreStatus;
  final GetChatParticipantsStatus getChatParticipantsStatus;
  final SearchUserStatus searchUserStatus;
  final List<UserEntity> searchUsers;
  final List<types.Message> messages;
  final ChatEntity? chatEntity;
  final UserEntity? userEntity;
  final String searchQuery;

  const ChatState({
    this.status = RealTimeMessageStatus.intial,
    this.sendMessageStatus = SendMessageStatus.intial,
    this.getChatByIdStatus = GetChatByIdStatus.initial,
    this.markChatAsReadStatus = MarkChatAsReadStatus.initial,
    this.getChatStatus = GetChatStatus.initial,
    this.deleteChatStatus = DeleteChatStatus.initial,
    this.getChatsStatus = GetChatsStatus.initial,
    this.getChatsMoreStatus = GetChatsMoreStatus.initial,
    this.getChatParticipantsStatus = GetChatParticipantsStatus.initial,
    this.searchUserStatus = SearchUserStatus.initial,
    this.searchUsers = const [],
    this.chatParticipants = const {},
    this.messages = const [],
    this.chatEntity,
    this.userEntity,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
        chatParticipants,
        status,
        sendMessageStatus,
        getChatByIdStatus,
        getChatStatus,
        deleteChatStatus,
        getChatsStatus,
        getChatsMoreStatus,
        markChatAsReadStatus,
        getChatParticipantsStatus,
        searchUserStatus,
        searchUsers,
        messages,
        chatEntity,
        userEntity,
        searchQuery,
      ];

  ChatState copyWith({
    Map<String, ChatParticipantEntity>? chatParticipants,
    RealTimeMessageStatus? status,
    SendMessageStatus? sendMessageStatus,
    GetChatByIdStatus? getChatByIdStatus,
    GetChatStatus? getChatStatus,
    DeleteChatStatus? deleteChatStatus,
    GetChatsStatus? getChatsStatus,
    GetChatsMoreStatus? getChatsMoreStatus,
    MarkChatAsReadStatus? markChatAsReadStatus,
    GetChatParticipantsStatus? getChatParticipantsStatus,
    SearchUserStatus? searchUserStatus,
    List<UserEntity>? searchUsers,
    List<types.Message>? messages,
    ChatEntity? chatEntity,
    UserEntity? userEntity,
    String? searchQuery,
  }) {
    return ChatState(
      chatParticipants: chatParticipants ?? this.chatParticipants,
      status: status ?? this.status,
      sendMessageStatus: sendMessageStatus ?? this.sendMessageStatus,
      getChatByIdStatus: getChatByIdStatus ?? this.getChatByIdStatus,
      getChatStatus: getChatStatus ?? this.getChatStatus,
      deleteChatStatus: deleteChatStatus ?? this.deleteChatStatus,
      getChatsStatus: getChatsStatus ?? this.getChatsStatus,
      getChatsMoreStatus: getChatsMoreStatus ?? this.getChatsMoreStatus,
      messages: messages ?? this.messages,
      markChatAsReadStatus: markChatAsReadStatus ?? this.markChatAsReadStatus,
      getChatParticipantsStatus:
          getChatParticipantsStatus ?? this.getChatParticipantsStatus,
      chatEntity: chatEntity ?? this.chatEntity,
      userEntity: userEntity ?? this.userEntity,
      searchUserStatus: searchUserStatus ?? this.searchUserStatus,
      searchUsers: searchUsers ?? this.searchUsers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
