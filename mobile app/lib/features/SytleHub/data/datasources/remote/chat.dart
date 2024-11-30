import 'dart:convert';

import 'package:http/http.dart' show Client;
import '../../models/chat/chat_model.dart';
import '../../models/chat/chat_participant_model.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../setUp/url/urls.dart';
import '../../models/chat/chat_user_with_last_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats({
    required String token,
    required String receiverId,
    required int skip,
    required int limit,
  });

  Future<ChatModel> sendMessage({
    required String token,
    required String receiverId,
    required String message,
    required int type,
  });

  Future<ChatModel> getChat({
    required String token,
    required String chatId,
  });

  Future<ChatModel> deleteChat({
    required String token,
    required String chatId,
  });

  Future<List<ChatParticipantModel>> getChatParticipants({
    required String token,
    required int skip,
    required int limit,
  });

  Future<List<ChatUserWithLastMessageModel>>
      getChatParticipantsWithLastMessage({
    required String token,
    required int skip,
    required int limit,
  });

  Future<void> markChatAsRead(
      {required String token,
      required String senderId,
      required String chatId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Client client;

  ChatRemoteDataSourceImpl({required this.client});

  @override
  Future<ChatModel> deleteChat(
      {required String token, required String chatId}) async {
    final response = await client.delete(Uri.parse("${Urls.chat}/$chatId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      return ChatModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ChatModel> getChat(
      {required String token, required String chatId}) async {
    final response = await client.get(Uri.parse("${Urls.chat}/$chatId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      return ChatModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ChatParticipantModel>> getChatParticipants(
      {required String token, required int skip, required int limit}) async {
    final response = await client
        .get(Uri.parse("${Urls.chat}/Users?skip=$skip&limit=$limit"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ChatParticipantModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ChatModel>> getChats(
      {required String token,
      required String receiverId,
      required int skip,
      required int limit}) async {
    final response = await client.get(
        Uri.parse("${Urls.chat}/Between/$receiverId?skip=$skip&limit=$limit"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ChatModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ChatModel> sendMessage(
      {required String token,
      required String receiverId,
      required String message,
      required int type}) async {
    final response = await client.post(Uri.parse(Urls.chat),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(
            {"receiverId": receiverId, "message": message, "type": type}));

    if (response.statusCode == 200) {
      return ChatModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ChatUserWithLastMessageModel>> getChatParticipantsWithLastMessage(
      {required String token, required int skip, required int limit}) async {
    final response = await client.get(
        Uri.parse("${Urls.chat}/Users/LastMessage?skip=$skip&limit=$limit"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ChatUserWithLastMessageModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<void> markChatAsRead(
      {required String token,
      required String senderId,
      required String chatId}) async {
    final response = await client.get(
      Uri.parse("${Urls.chat}/MarkRead/$chatId/sender/$senderId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }
}
