import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth.dart';

class UpdateAccessTokenUseCase extends UseCase<UserEntity, UpdateAccessTokenParams> {
  final AuthRepository repository;

  UpdateAccessTokenUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateAccessTokenParams params) async {
    return await repository.updateAccessToken(
      refreshToken: params.refeshToken,
    );
  }
}

class UpdateAccessTokenParams extends Equatable {
  final String refeshToken;

  const UpdateAccessTokenParams({required this.refeshToken});

  @override
  List<Object> get props => [refeshToken];
}
