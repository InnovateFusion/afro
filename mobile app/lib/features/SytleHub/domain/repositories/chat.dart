import 'package:either_dart/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/chat/chat_entity.dart';
import '../entities/chat/chat_participant_entity.dart';

import '../entities/chat/chat_user_with_last_message_entity.dart';
import '../entities/chat/real_time_chat_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getChats({
    required String token,
    required String receiverId,
    required int skip,
    required int limit,
  });

  Future<Either<Failure, ChatEntity>> sendMessage({
    required String token,
    required String receiverId,
    required String message,
    required int type,
  });

  Future<Either<Failure, ChatEntity>> getChat({
    required String token,
    required String chatId,
  });

  Future<Either<Failure, ChatEntity>> deleteChat({
    required String token,
    required String chatId,
  });

  Future<Either<Failure, List<ChatParticipantEntity>>> getChatParticipants({
    required String token,
    required int skip,
    required int limit,
  });

   Future<Either<Failure, List<ChatUserWithLastMessageEntity>>> getChatParticipantsWithLastMessage({
    required String token,
    required int skip,
    required int limit,
  });

  Future<Either<Failure, RealTimeChatEntity>> realTimeChatResponse({
    required String message,
  });

   Future<Either<Failure, void>> markChatAsRead({
    required String token,
    required String senderId,
    required String chatId,
  });

}
