import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failure.dart';
import '../../repositories/user.dart';

import '../../../../../core/use_cases/usecase.dart';
import '../../entities/user/user_entity.dart';

class ConnectFromTiktokUseCase extends UseCase<UserEntity, Params> {
  final UserRepository repository;

  ConnectFromTiktokUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    return await repository.connectFromTiktok(
        tiktokAccessToken: params.tiktokAccessToken,
        userAccessToken: params.userAccessToken);
  }
}

class Params extends Equatable {
  final String tiktokAccessToken;
  final String userAccessToken;

  const Params({
    required this.tiktokAccessToken,
    required this.userAccessToken,
  });

  @override
  List<Object> get props => [tiktokAccessToken, userAccessToken];
}
