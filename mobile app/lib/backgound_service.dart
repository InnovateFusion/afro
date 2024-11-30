import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/SytleHub/data/models/user/notification_model.dart';
import 'setUp/service/signalr_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );
}

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> showNotification(NotificationModelBackground notification) async {
  const String channelId = 'Afro Shops';
  const String channelName = 'Show Notification';

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelId,
    channelName,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'Ticker',
    playSound: true,
  );

  NotificationDetails platformChannelSpecifics = const NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    _getMessageTitle(notification),
    _getMessageBody(notification),
    platformChannelSpecifics,
    payload: jsonEncode(notification.toJson()),
  );
}

String _getMessageTitle(NotificationModelBackground notification) {
  switch (notification.type) {
    case 1:
      return "${notification.sender.firstName} sent you a message.";
    case 2:
      return "${notification.sender.firstName} reviewed your shop.";
    case 3:
      return "${notification.sender.firstName} started following your shop.";
    case 4:
      return "${notification.sender.firstName} favorited your product.";
    case 5:
      return "Latest updates about your shop.";
    case 6:
      return "${notification.sender.firstName} added a new product.";
    default:
      return "New Notification.";
  }
}

String _getMessageBody(NotificationModelBackground notification) {
  switch (notification.type) {
    case 1:
      if (notification.messageType == 0) {
        return notification.message;
      }
      return "Image message from ${notification.sender.firstName}.";
    case 2:
      return notification.message;
    case 3:
      return "More people started following your shop.";
    case 4:
      return "More people favorited your product.";
    case 5:
      return notification.message
          .substring(0, min(50, notification.message.length));
    case 6:
      return "See the new product added; it may interest you.";
    default:
      return "You have a new notification.";
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await initializeNotifications();

  final signalRService = SignalRService();
  await signalRService.startConnection();

  signalRService.hubConnection?.on('ReceiveMessage', (message) async {
    if (message != null && message.isNotEmpty) {
      if (message.length == 2) {
        if (message[0].toString() == 'notification') {
          final notification = NotificationModelBackground.fromJson(
              jsonDecode(message[1].toString()));
          await showNotification(notification);
        }
      }
    }
  });

  service.on("stop").listen((event) {
    service.stopSelf();
  });
}
