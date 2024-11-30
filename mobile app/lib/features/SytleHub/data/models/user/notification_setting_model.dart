
import '../../../domain/entities/user/notification_setting_entity.dart';

class NotificationSettingModel extends NotificationSettingEntity {
  const  NotificationSettingModel({required super.message, required super.review, required super.follow, required super.favorite, required super.verify});

  factory NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingModel(
      message: json['message'],
      review: json['review'],
      follow: json['follow'],
      favorite: json['favorite'],
      verify: json['verify'],
    );
  }
 
}
