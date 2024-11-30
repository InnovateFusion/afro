import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/user/notification_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/user.dart';

class GetNotificationsUsecase
    extends UseCase<List<NotificationEntity>, Params> {
  final UserRepository repository;

  GetNotificationsUsecase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(Params params) async {
    return await repository.getNotification(
      token: params.token,
      limit: params.limit,
      skip: params.skip,
    );
  }
}

class Params extends Equatable {
  final String token;
  final int limit;
  final int skip;

  const Params({
    required this.token,
    required this.limit,
    required this.skip,
  });

  @override
  List<Object> get props => [token, limit, skip];
}
