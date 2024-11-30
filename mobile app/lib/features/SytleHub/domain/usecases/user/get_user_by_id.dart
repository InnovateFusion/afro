import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/user/user_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/user.dart';

class GetUserByIdUsecase extends UseCase<UserEntity, Params> {
  final UserRepository repository;

  GetUserByIdUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    return await repository.getUserById(
      id: params.id,
    );
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id,});

  @override
  List<Object> get props => [id,];
}
