import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/user.dart';

class MarkAsReadNotificationsUsecase extends UseCase<bool, Params> {
  final UserRepository repository;

  MarkAsReadNotificationsUsecase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.markNotification(
      token: params.token,
    );
  }
}

class Params extends Equatable {
  final String token;

  const Params({required this.token});

  @override
  List<Object> get props => [token];
}
