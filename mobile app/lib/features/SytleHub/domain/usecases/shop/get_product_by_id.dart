import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/product/product_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class GetProductByIdUseCase extends UseCase<ProductEntity, Params> {
  final ShopRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(Params params) async {
    return await repository.getProductById(
      id: params.id,
    );
  }
}

class Params extends Equatable {
  final String id;

  const Params({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
