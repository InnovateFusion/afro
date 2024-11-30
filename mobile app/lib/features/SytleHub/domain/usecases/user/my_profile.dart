import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/user/notification_setting_entity.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user.dart';

class MyProfileUsecase extends UseCase<UserEntity, MyProfileParams> {
  final UserRepository repository;

  MyProfileUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(MyProfileParams params) async {
    return await repository.updateProfile(
      token: params.token,
      firstName: params.firstName,
      lastName: params.lastName,
      latitude: params.latitude,
      longitude: params.longitude,
      phoneNumber: params.phoneNumber,
      street: params.street,
      subLocality: params.subLocality,
      subAdministrativeArea: params.subAdministrativeArea,
      postalCode: params.postalCode,
      profilePictureBase64: params.profilePictureBase64,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
      productCategoryPreferences: params.productCategoryPreferences,
      productSizePreferences: params.productSizePreferences,
      productDesignPreferences: params.productDesignPreferences,
      productBrandPreferences: params.productBrandPreferences,
      productColorPreferences: params.productColorPreferences,
      notificationSetting: params.notificationSetting,
    );
  }
}

class MyProfileParams extends Equatable {
  final String token;
  final String? firstName;
  final String? lastName;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final String? street;
  final String? subLocality;
  final String? subAdministrativeArea;
  final String? postalCode;
  final String? profilePictureBase64;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? oldPassword;
  final String? newPassword;
  final String? productCategoryPreferences;
  final String? productSizePreferences;
  final String? productDesignPreferences;
  final String? productBrandPreferences;
  final String? productColorPreferences;
  final NotificationSettingEntity? notificationSetting;

  const MyProfileParams({
    required this.token,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.street,
    this.subLocality,
    this.subAdministrativeArea,
    this.postalCode,
    this.profilePictureBase64,
    this.dateOfBirth,
    this.gender,
    this.oldPassword,
    this.newPassword,
    this.productCategoryPreferences,
    this.productSizePreferences,
    this.productDesignPreferences,
    this.productBrandPreferences,
    this.productColorPreferences,
    this.notificationSetting,

  });

  @override
  List<Object?> get props => [
        token,
        firstName,
        lastName,
        latitude,
        longitude,
        phoneNumber,
        street,
        subLocality,
        subAdministrativeArea,
        postalCode,
        profilePictureBase64,
        dateOfBirth,
        gender,
        oldPassword,
        newPassword,
        productCategoryPreferences,
        productSizePreferences,
        productDesignPreferences,
        productBrandPreferences,
        productColorPreferences,
        notificationSetting,
      ];
}
