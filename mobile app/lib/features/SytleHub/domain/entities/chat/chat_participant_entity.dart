import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'chat_entity.dart';

class ChatParticipantEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String email;
  final String? profilePicture;
  final List<types.Message> chatEntities;
  final ChatEntity? lastMessage;

  const ChatParticipantEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.email,
    this.profilePicture,
    required this.chatEntities,
    this.lastMessage,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phoneNumber,
        email,
        profilePicture,
        chatEntities,
        lastMessage,
      ];

  ChatParticipantEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? profilePicture,
    List<types.Message>? chatEntities,
    ChatEntity? lastMessage,
  }) {
    return ChatParticipantEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      chatEntities: chatEntities ?? this.chatEntities,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}
