import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../../../../core/errors/exception.dart';
import '../../../../../setUp/url/urls.dart';
import '../../../domain/entities/user/notification_setting_entity.dart';
import '../../models/user/email_verify_model.dart';
import '../../models/user/notification_model.dart';
import '../../models/user/password_reset_request_model.dart';
import '../../models/user/password_reset_verification_model.dart';
import '../../models/user/tiktok_user_model.dart';
import '../../models/user/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<String> sendVerificationCode(String email);
  Future<EmailVerifyModel> verifyCode({
    required String email,
    required String code,
  });
  Future<PasswordResetRequestModel> resetPasswordRequest(String email);
  Future<PasswordResetVerificationModel> resetPasswordCodeVerification({
    required String email,
    required String code,
  });
  Future<UserModel> resetPassword({
    required String email,
    required String code,
    required String password,
  });

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    String? street,
    String? subLocality,
    String? subAdministrativeArea,
    String? postalCode,
    String? profilePictureBase64,
    DateTime? dateOfBirth,
    String? gender,
    String? oldPassword,
    String? newPassword,
    String? productCategoryPreferences,
    String? productSizePreferences,
    String? productDesignPreferences,
    String? productBrandPreferences,
    String? productColorPreferences,
    NotificationSettingEntity? notificationSetting,
    required String token,
  });

  Future<UserModel> getUserById({
    required String id,
  });

  //getUsers
  Future<List<UserModel>> getUsers(
      {required String search, required int limit, required int skip});

  Future<UserModel> updateAccessToken({required String refreshToken});

  Future<List<NotificationModel>> getNotification({
    required String token,
    required int skip,
    required int limit,
  });

  Future<bool> markNotification({
    required String token,
  });

  Future<UserModel> loginWithTiktok({required String accessCode});

  Future<UserModel> refereshTiktokAccessToken({required String refreshCode});

  Future<TiktokUserModel> getTiktokerProfileInfo({required String token});

  Future<UserModel> disConnectFromTiktok({
    required String tiktokAccessToken,
    required String userAccessToken,
  });

  Future<UserModel> connectFromTiktok({
    required String tiktokAccessToken,
    required String userAccessToken,
  });

  Future<String> sendProfileVerificationCode(
      {required String email, required String token});

  Future<EmailVerifyModel> verifyProfileCode({
    required String email,
    required String code,
    required String token,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Client client;

  UserRemoteDataSourceImpl({required this.client});

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
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse(Urls.signUp),
      body: jsonEncode({
        "registeration": {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password
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
  Future<String> sendVerificationCode(String email) async {
    final response = await client.post(
      Uri.parse(Urls.sendVerificationCode),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<EmailVerifyModel> verifyCode({
    required String email,
    required String code,
  }) async {
    final response = await client.post(
      Uri.parse(Urls.verifyCode),
      body: jsonEncode({'email': email, 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return EmailVerifyModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<PasswordResetRequestModel> resetPasswordRequest(String email) async {
    final response = await client.post(
      Uri.parse(Urls.resetPasswordRequest),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return PasswordResetRequestModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> resetPassword({
    required String email,
    required String password,
    required String code,
  }) async {
    final response = await client.post(
      Uri.parse(Urls.resetPassword),
      body: jsonEncode({'email': email, 'password': password, 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<PasswordResetVerificationModel> resetPasswordCodeVerification(
      {required String email, required String code}) async {
    final response = await client.post(
      Uri.parse(Urls.resetPasswordCodeVerification),
      body: jsonEncode({'email': email, 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return PasswordResetVerificationModel.fromJson(
          json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> updateProfile(
      {String? firstName,
      String? lastName,
      double? latitude,
      double? longitude,
      String? phoneNumber,
      String? street,
      String? subLocality,
      String? subAdministrativeArea,
      String? postalCode,
      String? profilePictureBase64,
      DateTime? dateOfBirth,
      String? gender,
      String? oldPassword,
      String? newPassword,
      String? productCategoryPreferences,
      String? productSizePreferences,
      String? productDesignPreferences,
      String? productBrandPreferences,
      String? productColorPreferences,
      NotificationSettingEntity? notificationSetting,
      required String token}) async {
    final response = await client.put(
      Uri.parse(Urls.user),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'latitude': latitude,
        'longitude': longitude,
        'phoneNumber': phoneNumber,
        'street': street,
        'subLocality': subLocality,
        'subAdministrativeArea': subAdministrativeArea,
        'postalCode': postalCode,
        'profilePictureBase64': profilePictureBase64,
        "password": newPassword,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "oldPassword": oldPassword,
        "gender": gender,
        "productCategoryPreferences": productCategoryPreferences,
        "productSizePreferences": productSizePreferences,
        "productDesignPreferences": productDesignPreferences,
        "productBrandPreferences": productBrandPreferences,
        "productColorPreferences": productColorPreferences,
        "notificationSettings": notificationSetting?.toMap(),
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
  Future<UserModel> getUserById({required String id}) async {
    final response = await client.get(
      Uri.parse('${Urls.user}/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<UserModel>> getUsers(
      {required String search, required int limit, required int skip}) async {
    final response = await client.get(
      Uri.parse(
          '${Urls.user}?Search=$search&Limit=$limit&Skip=$skip&SortBy=firstName&OrderBy=asc'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((e) => UserModel.fromJson(e)).toList();
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

  @override
  Future<List<NotificationModel>> getNotification(
      {required String token, required int skip, required int limit}) async {
    final response = await client.get(
      Uri.parse('${Urls.notification}/User?Skip=$skip&Limit=$limit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<bool> markNotification({required String token}) async {
    final response = await client.get(
      Uri.parse('${Urls.notification}/MarkAsRead'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> loginWithTiktok({required String accessCode}) async {
    final response = await client.get(
      Uri.parse('${Urls.loginWithTiktok}/$accessCode'),
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
  Future<UserModel> refereshTiktokAccessToken(
      {required String refreshCode}) async {
    final response = await client.get(
      Uri.parse('${Urls.refereshTiktok}/$refreshCode'),
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
  Future<TiktokUserModel> getTiktokerProfileInfo(
      {required String token}) async {
    final response = await client.get(
      Uri.parse(Urls.tiktokAuthUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return TiktokUserModel.fromJson(
          json.decode(response.body)['data']['user']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['error']['message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<UserModel> disConnectFromTiktok(
      {required String tiktokAccessToken,
      required String userAccessToken}) async {
    final response = await client.get(
      Uri.parse('${Urls.disConnectFromTiktok}/$tiktokAccessToken'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userAccessToken',
      },
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
  Future<UserModel> connectFromTiktok(
      {required String tiktokAccessToken,
      required String userAccessToken}) async {
    final response = await client.get(
      Uri.parse('${Urls.connectFromTiktok}/$tiktokAccessToken'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userAccessToken',
      },
    );
    print(response.body);
    print("----------xxs--------------");
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<String> sendProfileVerificationCode(
      {required String email, required String token}) async {
    final response = await client.post(
      Uri.parse(Urls.sendProfileVerificationCode),
      body: jsonEncode({'email': email}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<EmailVerifyModel> verifyProfileCode(
      {required String email,
      required String code,
      required String token}) async {
    final response = await client.post(
      Uri.parse(Urls.verifyProfileCode),
      body: jsonEncode({'email': email, 'code': code}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return EmailVerifyModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }
}
