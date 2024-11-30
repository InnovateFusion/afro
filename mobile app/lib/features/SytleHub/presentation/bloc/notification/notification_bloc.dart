import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:style_hub/features/SytleHub/domain/usecases/user/get_notifications.dart'
    as get_notifications;
import 'package:style_hub/features/SytleHub/domain/usecases/user/mark_notificaition_as_read.dart'
    as mark_notificaition_as_read;

import '../../../../../setUp/service/signalr_service.dart';
import '../../../domain/entities/user/notification_entity.dart';

part 'notification_event.dart';
part 'notification_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SignalRService _signalRService;
  final get_notifications.GetNotificationsUsecase getNotificationsUsecase;
  final mark_notificaition_as_read.MarkAsReadNotificationsUsecase
      markAsReadNotificationsUsecase;
  NotificationBloc({
    required SignalRService signalRService,
    required this.getNotificationsUsecase,
    required this.markAsReadNotificationsUsecase,
  })  : _signalRService = signalRService,
        super(const NotificationState()) {
    _signalRService.hubConnection?.keepAliveIntervalInMilliseconds = 300000;
    _signalRService.hubConnection?.on('ReceiveMessage', (message) async {
      if (message != null && message.isNotEmpty) {
        if (message.length == 2) {
          if (message[0].toString() == "notification") {
            add(IncrementCountEvent());
          }
        }
      }
    });

    on<ClearNotificationsEvent>((event, emit) {
      emit(const NotificationState());
    });

    on<SetCountToZeroEvent>((event, emit) {
      emit(state.copyWith(unreadCount: 0, notifications: []));
    });

    on<IncrementCountEvent>((event, emit) {
      emit(state.copyWith(unreadCount: state.unreadCount + 1));
    });

    on<GetNotificationsEvent>((event, emit) async {
      if (state.notifications.isNotEmpty) {
        emit(state.copyWith(notificationStatus: NotificationStatus.loadMore));
      } else {
        emit(state.copyWith(notificationStatus: NotificationStatus.loading));
      }
      final result = await getNotificationsUsecase(get_notifications.Params(
        token: event.token,
        limit: 20,
        skip: state.notifications.length,
      ));

      if (state.notifications.isEmpty) {
        await markAsReadNotificationsUsecase(mark_notificaition_as_read.Params(
          token: event.token,
        ));
      }

      result.fold((failure) {
        emit(state.copyWith(notificationStatus: NotificationStatus.failure));
      }, (notifications) {
        if (state.notifications.isEmpty) {
          int count = 0;
          for (final notification in notifications) {
            if (notification.isRead == false) {
              count++;
            }
          }
          emit(state.copyWith(
            notifications: notifications,
            notificationStatus: NotificationStatus.success,
            unreadCount: count,
          ));
          return;
        }
        emit(state.copyWith(
          notifications: [...state.notifications, ...notifications],
          notificationStatus: NotificationStatus.success,
        ));
      });
    }, transformer: throttleDroppable(throttleDuration));
  }
}
