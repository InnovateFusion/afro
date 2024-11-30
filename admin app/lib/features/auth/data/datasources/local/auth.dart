import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/errors/exception.dart';
import '../../models/notification_setting_model.dart';
import '../../models/role_model.dart';
import '../../models/user_model.dart';


abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getUser();
  Future<void> deleteUser();
  Future<UserModel> updateUser(UserModel user);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString('user', jsonEncode(user.toJson()));
  }

  @override
  Future<void> deleteUser() {
    return sharedPreferences.remove('user');
  }

  @override
  Future<UserModel> getUser() {
    final userJson = sharedPreferences.getString('user');
    if (userJson != null) {
      return Future.value(UserModel.fromJson(jsonDecode(userJson)));
    } else {
      throw const CacheException(message: 'No user cached');
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final oldUser = await getUser();
    final newUser = oldUser.copyWith(
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      email: user.email,
      latitude: user.latitude,
      longitude: user.longitude,
      profilePicture: user.profilePicture,
      postalCode: user.postalCode,
      subLocality: user.subLocality,
      subAdministrativeArea: user.subAdministrativeArea,
      gender: user.gender,
      dateOfBirth: user.dateOfBirth,
      street: user.street,
      token: user.token,
      refreshToken: user.refreshToken,
      tikTokAccessToken: user.tikTokAccessToken,
      tikTokRefreshToken: user.tikTokRefreshToken,
      role: RoleModel(
        id: user.role!.id,
        name: user.role!.name,
        description: user.role!.description,
      ),
      productCategoryPreferences: user.productCategoryPreferences,
      productSizePreferences: user.productSizePreferences,
      productDesignPreferences: user.productDesignPreferences,
      productBrandPreferences: user.productBrandPreferences,
      productColorPreferences: user.productColorPreferences,
      notificationSettings: NotificationSettingModel(
          message: user.notificationSettings!.message,
          review: user.notificationSettings!.review,
          follow: user.notificationSettings!.follow,
          favorite: user.notificationSettings!.favorite,
          verify: user.notificationSettings!.verify),
      isEmailVerified: user.isEmailVerified,
      version: user.version,
    );
    await cacheUser(newUser);
    return newUser;
  }
}
