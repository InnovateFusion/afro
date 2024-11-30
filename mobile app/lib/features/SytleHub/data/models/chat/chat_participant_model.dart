import '../../../domain/entities/chat/chat_participant_entity.dart';

class ChatParticipantModel extends ChatParticipantEntity {
  const ChatParticipantModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.chatEntities,
      required super.phoneNumber,
      required super.profilePicture});

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      chatEntities: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'chatEntities': chatEntities,
    };
  }
}
