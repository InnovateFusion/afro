import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/shop/working_hour_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class DeleteWorkingHourUseCase extends UseCase<WorkingHourEntity, Params> {
  final ShopRepository repository;

  DeleteWorkingHourUseCase(this.repository);

  @override
  Future<Either<Failure, WorkingHourEntity>> call(Params params) async {
    return await repository.deleteWorkingHour(
      id: params.id,
      token: params.token,
    );
  }
}

class Params extends Equatable {
  final String id;
  final String token;

  const Params({
    required this.id,
    required this.token,
  });

  @override
  List<Object?> get props => [
        token,
        id,
      ];
}
