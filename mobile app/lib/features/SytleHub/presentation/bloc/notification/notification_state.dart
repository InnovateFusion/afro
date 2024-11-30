part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, loadMore, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus notificationStatus;
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationState({
    this.notificationStatus = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
  });

  @override
  List<Object> get props => [notificationStatus, notifications, unreadCount];

  NotificationState copyWith({
    NotificationStatus? notificationStatus,
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationState(
      notificationStatus: notificationStatus ?? this.notificationStatus,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
