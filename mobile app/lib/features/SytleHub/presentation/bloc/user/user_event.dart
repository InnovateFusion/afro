part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class SignInEvent extends UserEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends UserEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class SendVerificationEmailRequestEvent extends UserEvent {
  final String email;

  SendVerificationEmailRequestEvent({required this.email});
}

class VerifyEmailEvent extends UserEvent {
  final String email;
  final String code;

  VerifyEmailEvent({required this.email, required this.code});
}

class VerifyPasswordCodeEvent extends UserEvent {
  final String email;
  final String code;

  VerifyPasswordCodeEvent({required this.email, required this.code});
}

class ResetPasswordRequestEvent extends UserEvent {
  final String email;

  ResetPasswordRequestEvent({required this.email});
}

class ResetPasswordEvent extends UserEvent {
  final String password;

  ResetPasswordEvent({
    required this.password,
  });
}

class ClearStateEvent extends UserEvent {}

class LoadCurrentUserEvent extends UserEvent {}

class SignOutEvent extends UserEvent {}

class UpdateProfileEvent extends UserEvent {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final String? street;
  final String? subLocality;
  final String? subAdministrativeArea;
  final String? postalCode;
  final File? profilePicture;
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

  UpdateProfileEvent({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.street,
    this.subLocality,
    this.subAdministrativeArea,
    this.postalCode,
    this.profilePicture,
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
}

class UpdateAccessTokenEvent extends UserEvent {
  UpdateAccessTokenEvent();
}

class LoginWithTiktokEvent extends UserEvent {
  final String accessCode;

  LoginWithTiktokEvent({
    required this.accessCode,
  });
}

class RefereshTiktokAccessTokenEvent extends UserEvent {
  RefereshTiktokAccessTokenEvent();
}

class ConnectToTiktokEvent extends UserEvent {
  final String accessCode;
  ConnectToTiktokEvent({
    required this.accessCode,
  });
}

class DisConnectFromTiktokEvent extends UserEvent {
  DisConnectFromTiktokEvent();
}

class GetTiktokerInfoEvent extends UserEvent {
  GetTiktokerInfoEvent();
}

class EmailVerifiedEvent extends UserEvent {
  final String email;
  EmailVerifiedEvent({required this.email});
}

class RefereshAllEvent extends UserEvent {
  final String token;
  RefereshAllEvent({required this.token});
}
