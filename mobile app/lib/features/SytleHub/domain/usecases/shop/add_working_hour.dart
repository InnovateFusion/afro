import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/shop/working_hour_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class AddWorkingHourUseCase extends UseCase<WorkingHourEntity, Params> {
  final ShopRepository repository;

  AddWorkingHourUseCase(this.repository);

  @override
  Future<Either<Failure, WorkingHourEntity>> call(Params params) async {
    return await repository.addWorkingHour(
      token: params.token,
      shopId: params.shopId,
      day: params.day,
      time: params.time,
    );
  }
}

class Params extends Equatable {
  final String token;
  final String shopId;
  final String day;
  final String time;

  const Params({
    required this.token,
    required this.shopId,
    required this.day,
    required this.time,
  });

  @override
  List<Object> get props => [shopId, day, time, token];
}
