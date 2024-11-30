import 'dart:convert';

import '../../../domain/entities/user/user_entity.dart';
import 'notification_setting_model.dart';
import 'role_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.phoneNumber,
    required super.email,
    super.latitude,
    super.longitude,
    super.profilePicture,
    super.street,
    super.subLocality,
    super.subAdministrativeArea,
    super.postalCode,
    super.token,
    super.refreshToken,
    super.tikTokAccessToken,
    super.tikTokRefreshToken,
    super.role,
    super.dateOfBirth,
    super.gender,
    super.productCategoryPreferences,
    super.productSizePreferences,
    super.productDesignPreferences,
    super.productBrandPreferences,
    super.productColorPreferences,
    super.notificationSettings,
    super.isEmailVerified,
    super.version,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'] ?? '',
      phoneNumber: json.containsKey('phoneNumber') ? json['phoneNumber'] : null,
      email: json['email'] ?? '',
      latitude: json.containsKey('latitude') ? json['latitude'] : null,
      longitude: json.containsKey('longitude') ? json['longitude'] : null,
      profilePicture:
          json.containsKey('profilePicture') ? json['profilePicture'] : null,
      street: json.containsKey('street') ? json['street'] : null,
      subLocality: json.containsKey('subLocality') ? json['subLocality'] : null,
      subAdministrativeArea: json.containsKey('subAdministrativeArea')
          ? json['subAdministrativeArea']
          : null,
      postalCode: json.containsKey('postalCode') ? json['postalCode'] : null,
      token: json.containsKey('token') ? json['token'] : null,
      refreshToken:
          json.containsKey('refreshToken') ? json['refreshToken'] : null,
      tikTokAccessToken: json.containsKey('tikTokAccessToken')
          ? json['tikTokAccessToken']
          : null,
      tikTokRefreshToken: json.containsKey('tikTokRefreshToken')
          ? json['tikTokRefreshToken']
          : null,
      role: (json.containsKey('role') && json['role'] != null)
          ? RoleModel.fromJson(json['role'])
          : null,
      dateOfBirth: json.containsKey('dateOfBirth')
          ? json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'])
              : null
          : null,
      gender: json.containsKey('gender') ? json['gender'] : null,
      productCategoryPreferences:
          json.containsKey('productCategoryPreferences') &&
                  json['productCategoryPreferences'] != null
              ? (json['productCategoryPreferences'] is String
                  ? jsonDecode(json['productCategoryPreferences'])
                      .map<String>((e) => e.toString())
                      .toList()
                  : <String>[]) // Handle case if it's not a string
              : null,
      productSizePreferences: json.containsKey('productSizePreferences') &&
              json['productSizePreferences'] != null
          ? (json['productSizePreferences'] is String
              ? jsonDecode(json['productSizePreferences'])
                  .map<String>((e) => e.toString())
                  .toList()
              : <String>[]) // Handle case if it's not a string
          : null,
      productDesignPreferences: json.containsKey('productDesignPreferences') &&
              json['productDesignPreferences'] != null
          ? (json['productDesignPreferences'] is String
              ? jsonDecode(json['productDesignPreferences'])
                  .map<String>((e) => e.toString())
                  .toList()
              : <String>[]) // Handle case if it's not a string
          : null,
      productBrandPreferences: json.containsKey('productBrandPreferences') &&
              json['productBrandPreferences'] != null
          ? (json['productBrandPreferences'] is String
              ? jsonDecode(json['productBrandPreferences'])
                  .map<String>((e) => e.toString())
                  .toList()
              : <String>[]) // Handle case if it's not a string
          : null,
      productColorPreferences: json.containsKey('productColorPreferences') &&
              json['productColorPreferences'] != null
          ? (json['productColorPreferences'] is String
              ? jsonDecode(json['productColorPreferences'])
                  .map<String>((e) => e.toString())
                  .toList()
              : <String>[]) // Handle case if it's not a string
          : null,
      notificationSettings: json.containsKey('notificationSettings')
          ? NotificationSettingModel.fromJson(json['notificationSettings'])
          : null,
      isEmailVerified: json.containsKey('isEmailVerified')
          ? json['isEmailVerified'] ?? false
          : false,
      version: json.containsKey('version') ? json['version'] : '1.0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'profilePicture': profilePicture,
      'street': street,
      'subLocality': subLocality,
      'subAdministrativeArea': subAdministrativeArea,
      'postalCode': postalCode,
      'token': token,
      'refreshToken': refreshToken,
      'tikTokAccessToken': tikTokAccessToken,
      'tikTokRefreshToken': tikTokRefreshToken,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'role': role?.toMap(),
      'productCategoryPreferences': productCategoryPreferences,
      'productSizePreferences': productSizePreferences,
      'productDesignPreferences': productDesignPreferences,
      'productBrandPreferences': productBrandPreferences,
      'productColorPreferences': productColorPreferences,
      'notificationSettings': notificationSettings?.toMap(),
      'isEmailVerified': isEmailVerified,
      'version': version,
    };
  }

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


  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    double? latitude,
    double? longitude,
    String? profilePicture,
    String? postalCode,
    String? street,
    String? subLocality,
    String? subAdministrativeArea,
    String? token,
    String? refreshToken,
    String? tikTokAccessToken,
    String? tikTokRefreshToken,
    RoleModel? role,
    String? gender,
    DateTime? dateOfBirth,
    List<String>? productCategoryPreferences,
    List<String>? productSizePreferences,
    List<String>? productDesignPreferences,
    List<String>? productBrandPreferences,
    List<String>? productColorPreferences,
    NotificationSettingModel? notificationSettings,
    bool? isEmailVerified,
    String? version,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      profilePicture: profilePicture ?? this.profilePicture,
      street: street ?? this.street,
      subLocality: subLocality ?? this.subLocality,
      subAdministrativeArea:
          subAdministrativeArea ?? this.subAdministrativeArea,
      postalCode: postalCode ?? this.postalCode,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      tikTokAccessToken: tikTokAccessToken ?? this.tikTokAccessToken,
      tikTokRefreshToken: tikTokRefreshToken ?? this.tikTokRefreshToken,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
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
