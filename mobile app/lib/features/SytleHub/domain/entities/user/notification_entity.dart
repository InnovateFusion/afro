import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String message;
  final int type;
  final bool isRead;
  final String typeId;
  final DateTime createdAt;
  final SenderEntity sender;
  final int messageType;
  final bool isAdmin;
  const NotificationEntity({
    required this.id,
    required this.message,
    required this.type,
    required this.typeId,
    required this.isRead,
    required this.createdAt,
    required this.sender,
    required this.messageType,
    required this.isAdmin,
  });

  @override
  List<Object?> get props => [
        id,
        message,
        type,
        isRead,
        createdAt,
        sender,
        typeId,
        messageType,
        isAdmin
      ];
}

class SenderEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String profilePicture;

  const SenderEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, profilePicture];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}
