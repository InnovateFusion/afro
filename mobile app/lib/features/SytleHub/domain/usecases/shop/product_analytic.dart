import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/shop/analytic_product_entity.dart';
import '../../repositories/shop.dart';

class ProductAnalyticUseCase extends UseCase<AnalyticProductEntity, Params> {
  final ShopRepository repository;

  ProductAnalyticUseCase(this.repository);

  @override
  Future<Either<Failure, AnalyticProductEntity>> call(Params params) async {
    return await repository.getProductAnalytic(
        id: params.id, token: params.token);
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
