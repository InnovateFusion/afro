import 'dart:convert';

import 'package:either_dart/src/either.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/remote/chat.dart';
import '../models/chat/real_time_chat_model.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../../domain/entities/chat/chat_participant_entity.dart';
import '../../domain/entities/chat/chat_user_with_last_message_entity.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/network/internet.dart';
import '../../domain/entities/chat/real_time_chat_entity.dart';
import '../../domain/repositories/chat.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ChatEntity>> deleteChat(
      {required String token, required String chatId}) async {
    if (await networkInfo.isConnected) {
      try {
        final chat =
            await remoteDataSource.deleteChat(token: token, chatId: chatId);
        return Right(chat);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChat(
      {required String token, required String chatId}) async {
    if (await networkInfo.isConnected) {
      try {
        final chat =
            await remoteDataSource.getChat(token: token, chatId: chatId);
        return Right(chat);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ChatParticipantEntity>>> getChatParticipants(
      {required String token, required int skip, required int limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final chatParticipants = await remoteDataSource.getChatParticipants(
            token: token, skip: skip, limit: limit);
        return Right(chatParticipants);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats(
      {required String token,
      required String receiverId,
      required int skip,
      required int limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final chats = await remoteDataSource.getChats(
            token: token, receiverId: receiverId, skip: skip, limit: limit);
        return Right(chats);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> sendMessage(
      {required String token,
      required String receiverId,
      required String message,
      required int type}) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remoteDataSource.sendMessage(
            token: token, receiverId: receiverId, message: message, type: type);
        return Right(chat);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, RealTimeChatEntity>> realTimeChatResponse(
      {required String message}) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = RealTimeChatModel.fromJson(jsonDecode(message));
        return Right(chat);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ChatUserWithLastMessageEntity>>>
      getChatParticipantsWithLastMessage(
          {required String token,
          required int skip,
          required int limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final chatParticipants =
            await remoteDataSource.getChatParticipantsWithLastMessage(
                token: token, skip: skip, limit: limit);
        return Right(chatParticipants);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> markChatAsRead(
      {required String token, required String senderId, required String chatId}) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remoteDataSource.markChatAsRead(
            token: token, senderId: senderId, chatId: chatId);
        return Right(chat);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }
}
