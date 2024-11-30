import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product.dart';

class AddNewProductUseCase extends UseCase<ProductEntity, AddNewProductParams> {
  final ProductRepository repository;

  AddNewProductUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(
      AddNewProductParams params) async {
    return await repository.addNewProduct(
      product: params.product,
    );
  }
}

class AddNewProductParams extends Equatable {
  final String product;

  const AddNewProductParams({
    required this.product,
  });

  @override
  List<Object?> get props => [product];
}
