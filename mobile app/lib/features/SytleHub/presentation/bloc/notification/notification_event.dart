part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  final String token;
 const GetNotificationsEvent({required this.token});
}

class ClearNotificationsEvent extends NotificationEvent {}

class SetCountToZeroEvent extends NotificationEvent {}

class IncrementCountEvent extends NotificationEvent {}