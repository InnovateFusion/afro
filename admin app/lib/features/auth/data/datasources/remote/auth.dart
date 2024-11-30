import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../../../../core/errors/exception.dart';
import '../../../../../setUp/url/urls.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> updateAccessToken({required String refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signIn(
      {required String email, required String password}) async {
    final response = await client.post(
      Uri.parse(Urls.signIn),
      body: jsonEncode({
        "loginRequest": {
          "email": email,
          "password": password,
        }
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> updateAccessToken({required String refreshToken}) async {
    final response = await client.get(
      Uri.parse('${Urls.updateAccessTokens}/$refreshToken'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }
}
