import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product.dart';

class GetProductUseCase extends UseCase<List<ProductEntity>, GetProductParams> {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(GetProductParams params) async {
    return await repository.getProducts(
      token: params.token,
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetProductParams extends Equatable {
  final String token;
  final int? skip;
  final int? limit;

  const GetProductParams({
    required this.token,

    this.skip,
    this.limit,
  });

  @override
  List<Object?> get props => [token, skip, limit];
}