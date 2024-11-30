import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user.dart';

class LoginWithTiktokUsecase extends UseCase<UserEntity, Params> {
  final UserRepository repository;

  LoginWithTiktokUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    return await repository.loginWithTiktok(accessCode: params.accessCode);
  }
}

class Params extends Equatable {
  final String accessCode;

  const Params({
    required this.accessCode,
  });

  @override
  List<Object> get props => [accessCode];
}
