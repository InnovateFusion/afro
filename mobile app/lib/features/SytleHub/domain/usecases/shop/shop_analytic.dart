import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/shop/analytic_shop_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class ShopAnalyticUseCase extends UseCase<AnalyticShopEntity, Params> {
  final ShopRepository repository;

  ShopAnalyticUseCase(this.repository);

  @override
  Future<Either<Failure, AnalyticShopEntity>> call(Params params) async {
    return await repository.getShopAnalytic(id: params.id, token: params.token);
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
  List<Object> get props => [id, token];
}
