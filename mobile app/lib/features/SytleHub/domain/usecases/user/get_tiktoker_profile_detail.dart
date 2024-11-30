import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/user/tiktok_user_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/user.dart';

class GetTiktokerProfileDetailUseCase extends UseCase<TiktokUserEntity, Params> {
  final UserRepository repository;

  GetTiktokerProfileDetailUseCase(this.repository);

  @override
  Future<Either<Failure, TiktokUserEntity>> call(Params params) async {
    return await repository.getTiktokerProfileInfo(
      token: params.token,
    );
  }
}

class Params extends Equatable {
  final String token;

  const Params({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}
