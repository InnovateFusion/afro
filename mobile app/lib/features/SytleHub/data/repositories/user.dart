import 'package:either_dart/either.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/internet.dart';
import '../../domain/entities/user/notification_entity.dart';
import '../../domain/entities/user/notification_setting_entity.dart';
import '../../domain/entities/user/password_reset_request_entity.dart';
import '../../domain/entities/user/password_reset_verification_entity.dart';
import '../../domain/entities/user/tiktok_user_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/user.dart';
import '../datasources/local/user.dart';
import '../datasources/remote/user.dart';
import '../models/user/email_verify_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user =
            await remoteDataSource.signIn(email: email, password: password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        );
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendVerificationCode({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.sendVerificationCode(email);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, EmailVerifyModel>> verifyCode({
    required String email,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.verifyCode(
          email: email,
          code: code,
        );
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PasswordResetRequestEntity>> resetPasswordRequest({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.resetPasswordRequest(email);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> resetPassword({
    required String email,
    required String password,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.resetPassword(
            email: email, password: password, code: code);

        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PasswordResetVerificationEntity>>
      resetPasswordCodeVerification(
          {required String email, required String code}) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.resetPasswordCodeVerification(
            email: email, code: code);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      return Right(await localDataSource.deleteUser());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.updateProfile(
          firstName: firstName,
          lastName: lastName,
          latitude: latitude,
          longitude: longitude,
          street: street,
          phoneNumber: phoneNumber,
          subLocality: subLocality,
          subAdministrativeArea: subAdministrativeArea,
          postalCode: postalCode,
          profilePictureBase64: profilePictureBase64,
          token: token,
          dateOfBirth: dateOfBirth,
          gender: gender,
          oldPassword: oldPassword,
          newPassword: newPassword,
          productCategoryPreferences: productCategoryPreferences,
          productSizePreferences: productSizePreferences,
          productDesignPreferences: productDesignPreferences,
          productBrandPreferences: productBrandPreferences,
          productColorPreferences: productColorPreferences,
          notificationSetting: notificationSetting,
        );
        final newUser = await localDataSource.updateUser(user);
        return Right(newUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getUserById(id: id);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers(
      {required String search, required int limit, required int skip}) async {
    if (await networkInfo.isConnected) {
      try {
        final users = await remoteDataSource.getUsers(
            search: search, limit: limit, skip: skip);
        return Right(users);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateAccessToken(
      {required String refreshToken}) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.updateAccessToken(
            refreshToken: refreshToken);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotification(
      {required String token, required int skip, required int limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final notification = await remoteDataSource.getNotification(
            token: token, skip: skip, limit: limit);
        return Right(notification);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> markNotification(
      {required String token}) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.markNotification(token: token);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithTiktok(
      {required String accessCode}) async {
    if (await networkInfo.isConnected) {
      try {
        final user =
            await remoteDataSource.loginWithTiktok(accessCode: accessCode);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> refereshTiktokAccessToken(
      {required String refreshCode}) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.refereshTiktokAccessToken(
            refreshCode: refreshCode);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TiktokUserEntity>> getTiktokerProfileInfo(
      {required String token}) async {
    if (await networkInfo.isConnected) {
      try {
        final user =
            await remoteDataSource.getTiktokerProfileInfo(token: token);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> disConnectFromTiktok(
      {required String tiktokAccessToken,
      required String userAccessToken}) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.disConnectFromTiktok(
            tiktokAccessToken: tiktokAccessToken,
            userAccessToken: userAccessToken);
        await localDataSource.getUser();
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> connectFromTiktok(
      {required String tiktokAccessToken,
      required String userAccessToken}) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.connectFromTiktok(
            tiktokAccessToken: tiktokAccessToken,
            userAccessToken: userAccessToken);
         await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendProfileVerificationCode(
      {required String email, required String token}) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.sendProfileVerificationCode(
            email: email, token: token);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, EmailVerifyModel>> verifyProfileCode(
      {required String email,
      required String code,
      required String token}) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.verifyProfileCode(
          email: email,
          code: code,
          token: token,
        );
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }
}
