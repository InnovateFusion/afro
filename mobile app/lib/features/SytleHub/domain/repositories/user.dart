import 'package:either_dart/either.dart';
import '../entities/user/notification_entity.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/user/email_verify_model.dart';
import '../entities/user/notification_setting_entity.dart';
import '../entities/user/password_reset_request_entity.dart';
import '../entities/user/password_reset_verification_entity.dart';
import '../entities/user/tiktok_user_entity.dart';
import '../entities/user/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> sendVerificationCode({
    required String email,
  });

  Future<Either<Failure, EmailVerifyModel>> verifyCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, PasswordResetRequestEntity>> resetPasswordRequest({
    required String email,
  });

  Future<Either<Failure, PasswordResetVerificationEntity>>
      resetPasswordCodeVerification({
    required String email,
    required String code,
  });

  Future<Either<Failure, UserEntity>> resetPassword({
    required String email,
    required String password,
    required String code,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, UserEntity>> updateProfile({
    required String token,
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
  });

  Future<Either<Failure, UserEntity>> getUserById({
    required String id,
  });

  Future<Either<Failure, List<UserEntity>>> getUsers({
    required String search,
    required int limit,
    required int skip,
  });

  Future<Either<Failure, UserEntity>> updateAccessToken({
    required String refreshToken,
  });

  Future<Either<Failure, List<NotificationEntity>>> getNotification({
    required String token,
    required int skip,
    required int limit,
  });

  Future<Either<Failure, bool>> markNotification({
    required String token,
  });

  Future<Either<Failure, UserEntity>> loginWithTiktok({
    required String accessCode,
  });

  Future<Either<Failure, UserEntity>> refereshTiktokAccessToken({
    required String refreshCode,
  });

  Future<Either<Failure, TiktokUserEntity>> getTiktokerProfileInfo({
    required String token,
  });

  Future<Either<Failure, UserEntity>> disConnectFromTiktok({
    required String tiktokAccessToken,
    required String userAccessToken,
  });

    Future<Either<Failure, UserEntity>> connectFromTiktok({
    required String tiktokAccessToken,
    required String userAccessToken,
  });

    Future<Either<Failure, String>> sendProfileVerificationCode({
    required String email,
    required String token,
  });

    Future<Either<Failure, EmailVerifyModel>> verifyProfileCode({
    required String email,
    required String code,
    required String token,
  });
}
