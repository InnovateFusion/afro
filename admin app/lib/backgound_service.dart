import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/product/data/models/product_model.dart';
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

Future<void> showNotification(String title, String message, int type) async {
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
    title,
    message,
    platformChannelSpecifics,
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await initializeNotifications();

  final signalRService = SignalRService();
  await signalRService.startConnection();

  signalRService.hubConnection?.on('ReceiveMessage', (message) async {
    if (message != null && message.isNotEmpty) {
      if (message.length == 2) {
        if (message[0].toString() == 'notification-for-admin-product') {
          final product =
              ProductModel.fromJson(jsonDecode(message[1].toString()));
          final title = "${product.shopInfo.name} added a new product.";
          final body = "Product: ${product.title}";
          await showNotification(title, body, 1);
        }
      }
    }
  });

  service.on("stop").listen((event) {
    service.stopSelf();
  });
}
