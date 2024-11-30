import 'package:either_dart/either.dart';

import '../../../../core/errors/failure.dart';
import '../entities/shop_entity.dart';

abstract class ShopRepository {
  Future<Either<Failure, List<ShopEntity>>> getShops({
    required String token,
    int? skip = 0,
    int? limit = 15,
  });
}
