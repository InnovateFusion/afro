import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user.dart';

class RefereshTiktokAccessTokenUseCase extends UseCase<UserEntity, Params> {
  final UserRepository repository;

  RefereshTiktokAccessTokenUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    return await repository.refereshTiktokAccessToken(
        refreshCode: params.refreshCode);
  }
}

class Params extends Equatable {
  final String refreshCode;

  const Params({
    required this.refreshCode,
  });

  @override
  List<Object> get props => [refreshCode];
}
