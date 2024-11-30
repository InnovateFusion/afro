import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/shop/working_hour_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class UpdateWorkingHourUseCase extends UseCase<WorkingHourEntity, Params> {
  final ShopRepository repository;

  UpdateWorkingHourUseCase(this.repository);

  @override
  Future<Either<Failure, WorkingHourEntity>> call(Params params) async {
    return await repository.updateWorkingHour(
      token: params.token,
      id: params.id,
      day: params.day,
      time: params.time,
    );
  }
}

class Params extends Equatable {
  final String token;
  final String id;
  final String day;
  final String time;

  const Params({
    required this.token,
    required this.id,
    required this.day,
    required this.time,
  });

  @override
  List<Object> get props => [id, day, time, token];
}
