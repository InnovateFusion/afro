import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/delete_chat_usecase.dart'
    as delete_chat_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/get_chat_participants_usecase.dart'
    as get_chat_participants_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/get_chat_participants_with_last_message_usecase.dart'
    as get_chat_participants_with_last_message_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/get_chat_usecase.dart'
    as get_chat_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/get_chats_usecase.dart'
    as get_chats_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/mark_chat_as_read_usecase.dart'
    as mark_chat_as_read_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/realtime_chat_response_usecase.dart'
    as realtime_chat_response_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/chat/send_message_usecase.dart'
    as send_message_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/user/get_user_by_id.dart'
    as get_user_by_id;
import 'package:style_hub/features/SytleHub/domain/usecases/user/get_users.dart'
    as get_users_usecase;
import 'package:style_hub/setUp/service/signalr_service.dart';
import 'package:style_hub/setUp/url/urls.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/chat/chat_entity.dart';
import '../../../domain/entities/chat/chat_participant_entity.dart';
import '../../../domain/entities/user/user_entity.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SignalRService signalRService;
  final get_chat_participants_usecase.GetChatParticipantsUsecase
      getChatParticipantsUseCase;
  final get_chats_usecase.GetChatsUsecase getChatsUsecase;
  final get_chat_usecase.GetChatUsecase getChatUsecase;
  final send_message_usecase.SendMessageUsecase sendMessageUsecase;
  final delete_chat_usecase.DeleteChatUsecase deleteChatUsecase;
  final realtime_chat_response_usecase.RealtimeChatResponseUsecase
      realtimeChatResponseUsecase;
  final get_user_by_id.GetUserByIdUsecase getUserByIdUsecase;
  final get_chat_participants_with_last_message_usecase
      .GetChatParticipantsWithLastMessageUsecase
      getChatParticipantsWithLastMessageUsecase;
  final mark_chat_as_read_usecase.MarkChatAsReadUsecase markChatAsReadUsecase;

  final get_users_usecase.GetUsersUsecase getUsersUsecase;

  ChatBloc({
    required this.signalRService,
    required this.getChatParticipantsUseCase,
    required this.getChatsUsecase,
    required this.getChatUsecase,
    required this.sendMessageUsecase,
    required this.deleteChatUsecase,
    required this.realtimeChatResponseUsecase,
    required this.getUserByIdUsecase,
    required this.getChatParticipantsWithLastMessageUsecase,
    required this.markChatAsReadUsecase,
    required this.getUsersUsecase,
  }) : super(const ChatState()) {
    signalRService.hubConnection?.keepAliveIntervalInMilliseconds = 600000;
    signalRService.hubConnection?.on('ReceiveMessage', (message) {
      if (message != null && message.isNotEmpty) {
        if (message.length == 2) {
          if (message[0].toString() == "chat") {
            add(ReceiveMessageEvent(message[1].toString()));
          } else if (message[0].toString() == "isChatDeleted") {
            add(RealTimeChatMessageDeletedEvent(
                message: message[1].toString()));
          } else if (message[0].toString() == "isChatRead") {
            add(RealTimeChatMarkAsReadEvent(message: message[1].toString()));
          }
        }
      }
    });

    on<SendRealTimeMessageEvent>(_sendMessage);

    on<GetChatsEvent>(_getChats);

    on<GetChatsMoreEvent>(_getChatsMore);

    on<GetChatByIdEvent>(_getChatById);

    on<DeleteChatEvent>(_deleteChat);

    on<GetChatParticipantsEvent>(_getChatParticipants);

    on<SendMessageEvent>(_sendMessageEvent);

    on<SendImageMessageEvent>(_sendImageMessageEvent);

    on<ReceiveMessageEvent>(_receiveMessage);

    on<RealTimeChatMessageDeletedEvent>(_realTimeChatMessageDeleted);

    on<RealTimeChatMarkAsReadEvent>(_realTimeChatMarkAsRead);

    on<MarkChatAsReadEvent>(_markChatAsRead);

    on<SearchUserEvent>(_searchUser);

    on<SignalRStartEvent>((event, emit) async {
      if (signalRService.isConnected) {
        return;
      }
      emit(state.copyWith(status: RealTimeMessageStatus.connecting));
      await signalRService.startConnection();
      emit(state.copyWith(status: RealTimeMessageStatus.connected));
    });

    on<SignalRStopEvent>((event, emit) async {
      if (!signalRService.isConnected) {
        return;
      }
      await signalRService.stopConnection();
      emit(state.copyWith(status: RealTimeMessageStatus.disconnected));
    });

    on<SetCurrentUserEvent>((event, emit) async {
      emit(state.copyWith(userEntity: event.user));
    });

    on<ClearChatEvent>((event, emit) async {
      emit(const ChatState());
    });
  }

  void _markChatAsRead(
      MarkChatAsReadEvent event, Emitter<ChatState> emit) async {
    if (!signalRService.isConnected) {
      signalRService.startConnection();
    }

    emit(state.copyWith(markChatAsReadStatus: MarkChatAsReadStatus.loading));
    final result = await markChatAsReadUsecase(
        mark_chat_as_read_usecase.MarkChatAsReadParams(
      token: event.token,
      senderId: event.senderId,
      chatId: event.chatId,
    ));

    result.fold(
        (failure) => emit(
            state.copyWith(markChatAsReadStatus: MarkChatAsReadStatus.failure)),
        (success) {
      emit(state.copyWith(markChatAsReadStatus: MarkChatAsReadStatus.success));
    });
  }

  void _sendMessage(
      SendRealTimeMessageEvent event, Emitter<ChatState> emit) async {
    if (!signalRService.isConnected) {
      signalRService.startConnection();
    }
    try {
      await signalRService.sendMessage(event.message);
      emit(state.copyWith(status: RealTimeMessageStatus.sent));
    } catch (e) {
      emit(state.copyWith(status: RealTimeMessageStatus.error));
    }
  }

  void _getChatsMore(GetChatsMoreEvent event, Emitter<ChatState> emit) async {
    if (state.getChatsMoreStatus == GetChatsMoreStatus.noMore) {
      emit(state.copyWith(getChatsMoreStatus: GetChatsMoreStatus.noMore));
      return;
    }

    emit(state.copyWith(getChatsMoreStatus: GetChatsMoreStatus.loading));

    final result = await getChatsUsecase(get_chats_usecase.GetChatsParams(
      token: event.user?.token ?? '',
      receiverId: event.receiverId,
      limit: 10,
      skip: state.messages.length,
    ));

    result.fold(
        (failure) => emit(
            state.copyWith(getChatsMoreStatus: GetChatsMoreStatus.failure)),
        (chats) {
      if (chats.isEmpty) {
        emit(state.copyWith(getChatsMoreStatus: GetChatsMoreStatus.noMore));
        return;
      }
      final Map<String, ChatParticipantEntity> chatParticipants = {
        ...state.chatParticipants
      };
      final List<types.Message> messages = [...state.messages];

      Set<String> ids = {};
      for (var chat in messages) {
        ids.add(chat.id);
      }

      final types.User sender = types.User(
        id: event.user?.id ?? const Uuid().v4(),
        imageUrl: event.user?.profilePicture ?? Urls.dummyImage,
        firstName: event.user?.firstName ?? '',
        lastName: event.user?.lastName ?? '',
      );

      final types.User receiver = types.User(
        id: event.receiverId,
        imageUrl: state.chatParticipants[event.receiverId]?.profilePicture ??
            Urls.dummyImage,
        firstName: state.chatParticipants[event.receiverId]?.firstName ?? '',
        lastName: state.chatParticipants[event.receiverId]?.lastName ?? '',
      );

      for (var chat in chats) {
        if (ids.contains(chat.id)) {
          continue;
        }
        if (chat.type == 1) {
          messages.add(types.ImageMessage(
            author: (chat.senderId == event.user?.id) ? sender : receiver,
            createdAt: chat.createdAt.millisecondsSinceEpoch,
            name: '',
            id: chat.id,
            size: 50,
            uri: chat.message,
            showStatus: true,
            status: chat.isRead ? types.Status.seen : types.Status.delivered,
          ));
        } else {
          messages.add(types.TextMessage(
            author: (chat.senderId == event.user?.id) ? sender : receiver,
            createdAt: chat.createdAt.millisecondsSinceEpoch,
            id: chat.id,
            text: chat.message,
            showStatus: true,
            status: chat.isRead ? types.Status.seen : types.Status.delivered,
          ));
        }
      }

      chatParticipants[event.receiverId] =
          chatParticipants[event.receiverId]!.copyWith(chatEntities: messages);

      emit(state.copyWith(
        getChatsMoreStatus: GetChatsMoreStatus.success,
        chatParticipants: chatParticipants,
        messages: messages,
      ));
    });
  }

  void _getChats(GetChatsEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(getChatsStatus: GetChatsStatus.loading));

    if (!state.chatParticipants.containsKey(event.receiverId)) {
      final result = await getUserByIdUsecase(get_user_by_id.Params(
        id: event.receiverId,
      ));
      result.fold(
          (failure) =>
              emit(state.copyWith(getChatsStatus: GetChatsStatus.failure)),
          (user) {
        emit(state.copyWith(
          getChatsStatus: GetChatsStatus.success,
          chatParticipants: {
            ...state.chatParticipants,
            user.id: ChatParticipantEntity(
              id: user.id,
              firstName: user.firstName,
              lastName: user.lastName,
              email: user.email,
              profilePicture: user.profilePicture,
              phoneNumber: user.phoneNumber,
              chatEntities: const [],
            ),
          },
          messages: const [],
        ));
      });
    }
    final result = await getChatsUsecase(get_chats_usecase.GetChatsParams(
      token: event.user?.token ?? '',
      receiverId: event.receiverId,
      limit: 50,
      skip: 0,
    ));
    result.fold(
        (failure) =>
            emit(state.copyWith(getChatsStatus: GetChatsStatus.failure)),
        (chats) {
      if (chats.isEmpty) {
        emit(state.copyWith(getChatsStatus: GetChatsStatus.success, messages: [
          ...state.chatParticipants[event.receiverId]?.chatEntities ?? []
        ]));
        return;
      }

      final Map<String, ChatParticipantEntity> chatParticipants = {
        ...state.chatParticipants
      };
      final List<types.Message> messages = [];

      final types.User sender = types.User(
        id: event.user?.id ?? const Uuid().v4(),
        imageUrl: event.user?.profilePicture ?? Urls.dummyImage,
        firstName: event.user?.firstName ?? '',
        lastName: event.user?.lastName ?? '',
      );

      final types.User receiver = types.User(
        id: event.receiverId,
        imageUrl: state.chatParticipants[event.receiverId]?.profilePicture ??
            Urls.dummyImage,
        firstName: state.chatParticipants[event.receiverId]?.firstName ?? '',
        lastName: state.chatParticipants[event.receiverId]?.lastName ?? '',
      );

      for (var chat in chats) {
        if (chat.type == 1) {
          messages.add(types.ImageMessage(
            author: (chat.senderId == event.user?.id) ? sender : receiver,
            createdAt: chat.createdAt.millisecondsSinceEpoch,
            name: '',
            id: chat.id,
            size: 50,
            uri: chat.message,
            showStatus: true,
            status: chat.isRead ? types.Status.seen : types.Status.delivered,
          ));
        } else {
          messages.add(types.TextMessage(
            author: (chat.senderId == event.user?.id) ? sender : receiver,
            createdAt: chat.createdAt.millisecondsSinceEpoch,
            id: chat.id,
            text: chat.message,
            showStatus: true,
            status: chat.isRead ? types.Status.seen : types.Status.delivered,
          ));
        }
      }

      chatParticipants[event.receiverId] =
          chatParticipants[event.receiverId]!.copyWith(chatEntities: messages);

      emit(state.copyWith(
        getChatsStatus: GetChatsStatus.success,
        chatParticipants: chatParticipants,
        messages: messages,
      ));
    });
  }

  void _getChatById(GetChatByIdEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(getChatByIdStatus: GetChatByIdStatus.loading));
    final result = await getChatUsecase(get_chat_usecase.GetChatParams(
      token: event.token,
      id: event.chatId,
    ));
    result.fold(
        (failure) =>
            emit(state.copyWith(getChatByIdStatus: GetChatByIdStatus.failure)),
        (chat) {
      emit(
        state.copyWith(
            getChatByIdStatus: GetChatByIdStatus.success, chatEntity: chat),
      );
    });
  }

  void _deleteChat(DeleteChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(deleteChatStatus: DeleteChatStatus.loading));
    final result = await deleteChatUsecase(delete_chat_usecase.DeleteChatParams(
      token: event.token,
      id: event.chatId,
    ));
    result.fold(
        (failure) =>
            emit(state.copyWith(deleteChatStatus: DeleteChatStatus.failure)),
        (sucess) {
      emit(
        state.copyWith(
          deleteChatStatus: DeleteChatStatus.success,
          chatEntity: sucess,
        ),
      );
    });
  }

  void _getChatParticipants(
      GetChatParticipantsEvent event, Emitter<ChatState> emit) async {
    if (state.chatParticipants.isEmpty) {
      emit(state.copyWith(
          getChatParticipantsStatus: GetChatParticipantsStatus.loading));
    } else {
      emit(state.copyWith(
          getChatParticipantsStatus: GetChatParticipantsStatus.loadMore));
    }

    final result = await getChatParticipantsWithLastMessageUsecase(
        get_chat_participants_with_last_message_usecase
            .GetChatParticipantsWithLastMessageParams(
      token: event.token,
      limit: 20,
      skip: state.chatParticipants.length,
    ));
    result.fold(
        (failure) => emit(state.copyWith(
            getChatParticipantsStatus: GetChatParticipantsStatus.failure)),
        (success) {
      if (success.isEmpty) {
        emit(state.copyWith(
            getChatParticipantsStatus: GetChatParticipantsStatus.success));
        return;
      }

      final Map<String, ChatParticipantEntity> chatParticipants = {
        ...state.chatParticipants
      };

      for (var user in success) {
        chatParticipants[user.user.id] = ChatParticipantEntity(
          id: user.user.id,
          firstName: user.user.firstName,
          lastName: user.user.lastName,
          email: user.user.email,
          profilePicture: user.user.profilePicture,
          phoneNumber: user.user.phoneNumber,
          lastMessage: user.lastMessage,
          chatEntities: [
            user.lastMessage.type == 1
                ? types.ImageMessage(
                    author: types.User(
                      id: user.user.id,
                      imageUrl: user.user.profilePicture,
                      firstName: user.user.firstName,
                      lastName: user.user.lastName,
                    ),
                    createdAt:
                        user.lastMessage.createdAt.millisecondsSinceEpoch,
                    name: '',
                    id: user.lastMessage.id,
                    size: 50,
                    uri: user.lastMessage.message,
                    showStatus: true,
                    status: user.lastMessage.isRead
                        ? types.Status.seen
                        : types.Status.delivered,
                  )
                : types.TextMessage(
                    author: types.User(
                      id: user.user.id,
                      imageUrl: user.user.profilePicture,
                      firstName: user.user.firstName,
                      lastName: user.user.lastName,
                    ),
                    createdAt:
                        user.lastMessage.createdAt.millisecondsSinceEpoch,
                    id: user.lastMessage.id,
                    text: user.lastMessage.message,
                    showStatus: true,
                    status: user.lastMessage.isRead
                        ? types.Status.seen
                        : types.Status.delivered,
                  )
          ],
        );
      }

      emit(
        state.copyWith(
          getChatParticipantsStatus: GetChatParticipantsStatus.success,
          chatParticipants: chatParticipants,
        ),
      );
    });
  }

  void _sendMessageEvent(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    if (!signalRService.isConnected) {
      await signalRService.startConnection();
    }
    emit(
        state.copyWith(sendMessageStatus: SendMessageStatus.sending, messages: [
      ...state.messages,
    ]));
    final result =
        await sendMessageUsecase(send_message_usecase.SendMessageParams(
      message: event.message.text,
      receiverId: event.receiverId,
      token: event.token,
      type: event.type,
    ));

    result.fold(
        (failure) =>
            emit(state.copyWith(sendMessageStatus: SendMessageStatus.error)),
        (chat) {
      emit(
        state.copyWith(
          sendMessageStatus: SendMessageStatus.sent,
        ),
      );
    });
  }

  Future<String> _getBase64Image(File image) async {
    final File imageFile = File(image.path);
    if (!imageFile.existsSync()) {
      return '';
    }
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String base64ImageWithPrefix = "data:image/png;base64,$base64Image";
    return base64ImageWithPrefix;
  }

  void _sendImageMessageEvent(
      SendImageMessageEvent event, Emitter<ChatState> emit) async {
    signalRService.startConnection();
    emit(
        state.copyWith(sendMessageStatus: SendMessageStatus.sending, messages: [
      ...state.messages,
    ]));

    final result =
        await sendMessageUsecase(send_message_usecase.SendMessageParams(
      message: await _getBase64Image(event.logo),
      receiverId: event.receiverId,
      token: event.token,
      type: event.type,
    ));

    result.fold(
        (failure) =>
            emit(state.copyWith(sendMessageStatus: SendMessageStatus.error)),
        (chat) {
      emit(
        state.copyWith(
          sendMessageStatus: SendMessageStatus.sent,
        ),
      );
    });
  }

  void _receiveMessage(
      ReceiveMessageEvent event, Emitter<ChatState> emit) async {
    final result = await realtimeChatResponseUsecase(
        realtime_chat_response_usecase.RealtimeChatResponseParams(
      message: event.message,
    ));

    result.fold(
        (failure) => emit(state.copyWith(status: RealTimeMessageStatus.error)),
        (chat) {
      final Map<String, ChatParticipantEntity> chatParticipants = {
        ...state.chatParticipants,
      };

      bool isSenderMe = chat.senderId == state.userEntity?.id;
      final participantKey = isSenderMe ? chat.receiverId : chat.senderId;

      if (chatParticipants.containsKey(participantKey)) {
        final types.User user = types.User(
          id: chat.senderId,
          imageUrl: chat.senderAvatar,
          firstName: chat.senderName,
        );

        final message = chat.type == 1
            ? types.ImageMessage(
                author: user,
                createdAt: chat.createdAt.millisecondsSinceEpoch,
                name: '',
                id: chat.id,
                size: 50,
                uri: chat.message,
                showStatus: true,
                status:
                    chat.isRead ? types.Status.seen : types.Status.delivered,
              )
            : types.TextMessage(
                author: user,
                createdAt: chat.createdAt.millisecondsSinceEpoch,
                id: chat.id,
                text: chat.message,
                showStatus: true,
                status:
                    chat.isRead ? types.Status.seen : types.Status.delivered,
              );

        chatParticipants[participantKey] = ChatParticipantEntity(
          id: participantKey,
          firstName: chatParticipants[participantKey]?.firstName ?? '',
          lastName: chatParticipants[participantKey]?.lastName ?? '',
          email: chatParticipants[participantKey]?.email ?? '',
          profilePicture: isSenderMe ? chat.receiverAvatar : chat.senderAvatar,
          phoneNumber: '',
          lastMessage: ChatEntity(
              id: chat.id,
              createdAt: chat.createdAt,
              message: chat.message,
              senderId: chat.senderId,
              receiverId: chat.receiverId,
              isRead: chat.isRead,
              type: chat.type),
          chatEntities: [
            message,
            ...chatParticipants[participantKey]?.chatEntities ?? []
          ],
        );

        emit(state.copyWith(chatParticipants: {
          participantKey: chatParticipants[participantKey]!,
          ...chatParticipants,
        }, messages: [
          ...chatParticipants[participantKey]?.chatEntities ?? []
        ]));
      } else {
        final types.User user = types.User(
          id: isSenderMe ? chat.receiverId : chat.senderId,
          imageUrl: isSenderMe ? chat.receiverAvatar : chat.senderAvatar,
          firstName: isSenderMe ? chat.receiverName : chat.senderName,
        );

        chatParticipants[participantKey] = ChatParticipantEntity(
          id: participantKey,
          firstName: isSenderMe ? chat.receiverName : chat.senderName,
          lastName: '',
          email: '',
          profilePicture: isSenderMe ? chat.receiverAvatar : chat.senderAvatar,
          phoneNumber: '',
          lastMessage: ChatEntity(
              id: chat.id,
              createdAt: chat.createdAt,
              message: chat.message,
              senderId: chat.senderId,
              isRead: chat.isRead,
              receiverId: chat.receiverId,
              type: chat.type),
          chatEntities: [
            chat.type == 1
                ? types.ImageMessage(
                    author: user,
                    createdAt: chat.createdAt.millisecondsSinceEpoch,
                    name: '',
                    id: chat.id,
                    size: 50,
                    uri: chat.message,
                    showStatus: true,
                    status: chat.isRead
                        ? types.Status.seen
                        : types.Status.delivered,
                  )
                : types.TextMessage(
                    author: user,
                    createdAt: chat.createdAt.millisecondsSinceEpoch,
                    id: chat.id,
                    text: chat.message,
                    showStatus: true,
                    status: chat.isRead
                        ? types.Status.seen
                        : types.Status.delivered,
                  )
          ],
        );

        emit(state.copyWith(
          chatParticipants: {
            participantKey: chatParticipants[participantKey]!,
            ...chatParticipants,
          },
          messages: chatParticipants[participantKey]?.chatEntities ?? [],
        ));
      }
    });
  }

  void _realTimeChatMessageDeleted(
      RealTimeChatMessageDeletedEvent event, Emitter<ChatState> emit) async {
    final jsondata = jsonDecode(event.message);
    final receiverId = jsondata['receiverId'];
    final senderId = jsondata['senderId'];
    final chatId = jsondata['chatId'];

    final Map<String, ChatParticipantEntity> chatParticipants = {
      ...state.chatParticipants,
    };

    if (chatParticipants.containsKey(receiverId)) {
      final List<types.Message> messages = [];

      for (var chat in chatParticipants[receiverId]!.chatEntities) {
        if (chat.id != chatId) {
          messages.add(chat);
        }
      }

      chatParticipants[receiverId] =
          chatParticipants[receiverId]!.copyWith(chatEntities: messages);

      chatParticipants[receiverId] = chatParticipants[receiverId]!.copyWith(
        lastMessage: ChatEntity(
            id: chatParticipants[receiverId]!.chatEntities.isEmpty
                ? 'xxx'
                : chatParticipants[receiverId]!.chatEntities.first.id,
            createdAt: DateTime.now(),
            message: 'Message deleted',
            senderId: chatParticipants[receiverId]!.chatEntities.isEmpty
                ? 'xxx'
                : chatParticipants[receiverId]!.chatEntities.first.author.id,
            receiverId: receiverId,
            isRead: true,
            type: 0),
      );

      if (chatParticipants[receiverId]!.chatEntities.isEmpty) {
        chatParticipants.remove(receiverId);
      }

      emit(
        state.copyWith(
          deleteChatStatus: DeleteChatStatus.success,
          chatParticipants: chatParticipants,
          messages: messages,
        ),
      );
    } else if (chatParticipants.containsKey(senderId)) {
      final List<types.Message> messages = [];

      for (var chat in chatParticipants[senderId]!.chatEntities) {
        if (chat.id != chatId) {
          messages.add(chat);
        }
      }

      chatParticipants[senderId] =
          chatParticipants[senderId]!.copyWith(chatEntities: messages);

      chatParticipants[senderId] = chatParticipants[senderId]!.copyWith(
        lastMessage: ChatEntity(
            id: chatParticipants[senderId]!.chatEntities.isEmpty
                ? 'xxx'
                : chatParticipants[senderId]!.chatEntities.first.id,
            createdAt: DateTime.now(),
            message: 'Message deleted',
            senderId: chatParticipants[senderId]!.chatEntities.isEmpty
                ? 'xxx'
                : chatParticipants[senderId]!.chatEntities.first.author.id,
            receiverId: receiverId,
            isRead: true,
            type: 0),
      );

      if (chatParticipants[senderId]!.chatEntities.isEmpty) {
        chatParticipants.remove(senderId);
      }

      emit(
        state.copyWith(
          deleteChatStatus: DeleteChatStatus.success,
          chatParticipants: chatParticipants,
          messages: messages,
        ),
      );
    }
  }

  void _realTimeChatMarkAsRead(
      RealTimeChatMarkAsReadEvent event, Emitter<ChatState> emit) async {
    final jsondata = jsonDecode(event.message);
    final id = jsondata['receiverId'];
    final chatId = jsondata['chatId'];

    final Map<String, ChatParticipantEntity> chatParticipants = {
      ...state.chatParticipants,
    };

    if (chatParticipants.containsKey(id)) {
      final List<types.Message> messages = [];

      for (var chat in chatParticipants[id]!.chatEntities) {
        if (chat.id == chatId) {
          messages.add(chat.copyWith(status: types.Status.seen));
          if (chatParticipants[id]!.lastMessage!.id == chatId) {
            chatParticipants[id] = chatParticipants[id]!.copyWith(
              lastMessage: chatParticipants[id]!.lastMessage!.copyWith(
                    isRead: true,
                  ),
            );
          }
        } else {
          messages.add(chat);
        }
      }

      chatParticipants[id] =
          chatParticipants[id]!.copyWith(chatEntities: messages);

      emit(state.copyWith(
          chatParticipants: chatParticipants, messages: messages));
    } else {}
  }

  void _searchUser(SearchUserEvent event, Emitter<ChatState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
          searchUsers: const [],
          searchQuery: '',
          searchUserStatus: SearchUserStatus.initial));
      return;
    }
    if (event.query == state.searchQuery) {
      emit(state.copyWith(searchUserStatus: SearchUserStatus.loadMore));
    } else {
      emit(state.copyWith(
          searchUserStatus: SearchUserStatus.loading, searchUsers: const []));
    }
    final result = await getUsersUsecase(get_users_usecase.Params(
      search: event.query,
      skip: event.query == state.searchQuery ? state.searchUsers.length : 0,
      limit: 35,
    ));
    result.fold(
        (failure) =>
            emit(state.copyWith(searchUserStatus: SearchUserStatus.failure)),
        (users) {
      if (users.isEmpty) {
        emit(state.copyWith(searchUserStatus: SearchUserStatus.noMore));
        return;
      }
      emit(state.copyWith(
        searchUserStatus: SearchUserStatus.success,
        searchUsers: event.query == state.searchQuery
            ? [...state.searchUsers, ...users]
            : users,
        searchQuery: event.query,
      ));
    });
  }

  @override
  Future<void> close() {
    signalRService.dispose();
    return super.close();
  }
}
