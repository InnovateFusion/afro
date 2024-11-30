import '../../../domain/entities/user/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.message,
    required super.type,
    required super.typeId,
    required super.isRead,
    required super.createdAt,
    required super.sender,
    required super.messageType,
    required super.isAdmin,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message'],
      type: json['type'],
      typeId: json['typeId'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
      sender: SenderModel.fromJson(json['sender']),
      messageType: json['messageType'],
      isAdmin: json['isAdmin'],
    );
  }
}

class SenderModel extends SenderEntity {
  const SenderModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.profilePicture});

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }
}

class NotificationModelBackground extends NotificationEntity {
  const NotificationModelBackground(
      {required super.id,
      required super.message,
      required super.type,
      required super.typeId,
      required super.isRead,
      required super.createdAt,
      required super.sender,
      required super.messageType,
      required super.isAdmin});

  factory NotificationModelBackground.fromJson(Map<String, dynamic> json) {
    return NotificationModelBackground(
      id: json['Id'],
      message: json['Message'],
      type: json['Type'],
      typeId: json['TypeId'],
      isRead: json['IsRead'],
      createdAt: DateTime.parse(json['CreatedAt']),
      sender: SenderModelBackground.fromJson(json),
      messageType: json['MessageType'],
      isAdmin: json['IsAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Message': message,
      'Type': type,
      'TypeId': typeId,
      'IsRead': isRead,
      'CreatedAt': createdAt.toIso8601String(),
      'Sender': sender.toMap(),
      'MessageType': messageType,
      'IsAdmin': isAdmin,
    };
  }
}

class SenderModelBackground extends SenderEntity {
  const SenderModelBackground(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.profilePicture});

  factory SenderModelBackground.fromJson(Map<String, dynamic> json) {
    return SenderModelBackground(
      id: json['ReceiverId'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      profilePicture: json['Avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ReceiverId': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Avatar': profilePicture,
    };
  }
}
