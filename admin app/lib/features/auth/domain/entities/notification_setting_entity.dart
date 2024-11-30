import 'package:equatable/equatable.dart';

class NotificationSettingEntity extends Equatable {
  final bool message;
  final bool review;
  final bool follow;
  final bool favorite;
  final bool verify;

  const NotificationSettingEntity({
    required this.message,
    required this.review,
    required this.follow,
    required this.favorite,
    required this.verify,
  });

  @override
  List<Object?> get props => [message, review, follow, favorite, verify];

  NotificationSettingEntity copyWith({
    bool? message,
    bool? review,
    bool? follow,
    bool? favorite,
    bool? verify,
  }) {
    return NotificationSettingEntity(
      message: message ?? this.message,
      review: review ?? this.review,
      follow: follow ?? this.follow,
      favorite: favorite ?? this.favorite,
      verify: verify ?? this.verify,
    );
  }

  String toJson() {
    return '''
    {
      "message": $message,
      "review": $review,
      "follow": $follow,
      "favorite": $favorite,
      "verify": $verify
    }
    ''';
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'review': review,
      'follow': follow,
      'favorite': favorite,
      'verify': verify,
    };
  }
}
