import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/user/user_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/user.dart';

class GetUsersUsecase extends UseCase<List<UserEntity>, Params> {
  final UserRepository repository;

  GetUsersUsecase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(Params params) async {
    return await repository.getUsers(
      search: params.search,
      limit: params.limit,
      skip: params.skip,
    );
  }
}

class Params extends Equatable {
  final String search;
  final int limit;
  final int skip;

  const Params({
    required this.search,
    required this.limit,
    required this.skip,
  });

  @override
  List<Object> get props => [
        search, limit, skip
      ];
}
