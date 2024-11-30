import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/user/user_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/user.dart';

class UpdateAccessToken extends UseCase<UserEntity, Params> {
  final UserRepository repository;

  UpdateAccessToken(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    return await repository.updateAccessToken(
      refreshToken: params.refeshToken,
    );
  }
}

class Params extends Equatable {
  final String refeshToken;

  const Params({required this.refeshToken});

  @override
  List<Object> get props => [refeshToken];
}
