import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../features/auth/data/models/user_model.dart';
import '../url/urls.dart';

class SignalRService {
  HubConnection? _hubConnection;
  UserModel? _user;

  SignalRService() {
    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    final user = await getUser();
    _user = user;
    if (user == null) {
      print('User not found');
      return;
    }

    final token = '${user.token}';
    final httpConnectionOptions = HttpConnectionOptions(
      accessTokenFactory: () => Future.value(token),
      logMessageContent: true,
      transport: HttpTransportType.WebSockets,
      skipNegotiation: true,
      requestTimeout: 30000,
    );

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          Urls.socketIp,
          options: httpConnectionOptions,
        )
        .withAutomaticReconnect()
        .build();

    try {
      await _hubConnection!.start();
      print('Connection started');
    } catch (error) {
      print('Error starting connection: $error');
    }
  }

  Future<void> startConnection() async {
    if (_hubConnection == null ||
        _hubConnection!.state != HubConnectionState.Connected) {
      await _initializeConnection();
    }
  }

  Future<void> stopConnection() async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      await _hubConnection!.stop();
      print('Connection stopped');
    }
  }

  Future<void> sendMessage(String message) async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      try {
        await _hubConnection!.invoke('SendMessage', args: [message]);
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      print('Connection not initialized');
    }
  }

  Future<UserModel?> getUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userJson = sharedPreferences.getString('user');
    if (userJson == null) {
      return null;
    }
    return UserModel.fromJson(jsonDecode(userJson));
  }

  void dispose() {
    _hubConnection?.stop().catchError((error) {
      print('Error stopping connection: $error');
    });
  }

  HubConnection? get hubConnection => _hubConnection;
  UserModel? get user => _user;
  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;
}
