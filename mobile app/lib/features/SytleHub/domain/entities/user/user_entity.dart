import 'package:equatable/equatable.dart';

import 'notification_setting_entity.dart';
import 'role_entity.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String email;
  final double? latitude;
  final double? longitude;
  final String? profilePicture;
  final String? postalCode;
  final String? subLocality;
  final String? subAdministrativeArea;
  final String? street;
  final String? token;
  final String? refreshToken;
  final String? tikTokAccessToken;
  final String? tikTokRefreshToken;
  final DateTime? dateOfBirth;
  final String? gender;
  final RoleEntity? role;
  final List<String>? productCategoryPreferences;
  final List<String>? productSizePreferences;
  final List<String>? productDesignPreferences;
  final List<String>? productBrandPreferences;
  final List<String>? productColorPreferences;
  final NotificationSettingEntity? notificationSettings;
  final bool isEmailVerified;
  final String version;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.email,
    this.latitude,
    this.longitude,
    this.profilePicture,
    this.postalCode,
    this.subLocality,
    this.subAdministrativeArea,
    this.street,
    this.token,
    this.refreshToken,
    this.tikTokAccessToken,
    this.tikTokRefreshToken,
    this.role,
    this.dateOfBirth,
    this.gender,
    this.productCategoryPreferences,
    this.productSizePreferences,
    this.productDesignPreferences,
    this.productBrandPreferences,
    this.productColorPreferences,
    this.notificationSettings,
    this.isEmailVerified = false,
    this.version = '1.0.0',
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phoneNumber,
        email,
        latitude,
        longitude,
        profilePicture,
        postalCode,
        subLocality,
        subAdministrativeArea,
        street,
        token,
        refreshToken,
        tikTokAccessToken,
        tikTokRefreshToken,
        role,
        dateOfBirth,
        gender,
        productCategoryPreferences,
        productSizePreferences,
        productDesignPreferences,
        productBrandPreferences,
        productColorPreferences,
        notificationSettings,
        isEmailVerified,
        version,
      ];

  UserEntity copyWithObj({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    double? latitude,
    double? longitude,
    String? profilePicture,
    String? postalCode,
    String? subLocality,
    String? subAdministrativeArea,
    String? street,
    String? token,
    String? refreshToken,
    String? tikTokAccessToken,
    String? tikTokRefreshToken,
    DateTime? dateOfBirth,
    String? gender,
    RoleEntity? role,
    List<String>? productCategoryPreferences,
    List<String>? productSizePreferences,
    List<String>? productDesignPreferences,
    List<String>? productBrandPreferences,
    List<String>? productColorPreferences,
    NotificationSettingEntity? notificationSettings,
    bool? isEmailVerified,
    String? version,
  }) {
    return UserEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      profilePicture: profilePicture ?? this.profilePicture,
      postalCode: postalCode ?? this.postalCode,
      subLocality: subLocality ?? this.subLocality,
      subAdministrativeArea:
          subAdministrativeArea ?? this.subAdministrativeArea,
      street: street ?? this.street,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      tikTokAccessToken: tikTokAccessToken ?? this.tikTokAccessToken,
      tikTokRefreshToken: tikTokRefreshToken ?? this.tikTokRefreshToken,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      productCategoryPreferences:
          productCategoryPreferences ?? this.productCategoryPreferences,
      productSizePreferences:
          productSizePreferences ?? this.productSizePreferences,
      productDesignPreferences:
          productDesignPreferences ?? this.productDesignPreferences,
      productBrandPreferences:
          productBrandPreferences ?? this.productBrandPreferences,
      productColorPreferences:
          productColorPreferences ?? this.productColorPreferences,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      version: version ?? this.version,
    );
  }
}
