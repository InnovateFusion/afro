import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/product.dart';

class GetFavoriteUseCase extends UseCase<List<ProductEntity>, Params> {
  final ProductRepository repository;

  GetFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(Params params) async {
    return await repository.getProducts(
      token: params.token,
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class Params extends Equatable {
  final String token;
  final int? skip;
  final int? limit;

  const Params({
    required this.token,
    this.skip,
    this.limit,
  });

  @override
  List<Object?> get props => [
        token,
      ];
}
