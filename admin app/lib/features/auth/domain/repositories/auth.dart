import 'package:either_dart/either.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity>> updateAccessToken({
    required String refreshToken,
  });
}
