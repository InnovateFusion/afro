import '../entities/product_entity.dart';
import 'package:either_dart/either.dart';

import '../../../../core/errors/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required String token,
    int? skip = 0,
    int? limit = 15,
  });

  Future<Either<Failure, ProductEntity>> approvalReview({
    required String token,
    required String id,
    required int status,
  });

  Future<Either<Failure, ProductEntity>> addNewProduct({
    required String product,
  });

}
