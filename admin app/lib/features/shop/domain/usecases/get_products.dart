import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../entities/shop_entity.dart';
import '../repositories/shop.dart';

class GetShopUseCase extends UseCase<List<ShopEntity>, GetShopParams> {
  final ShopRepository repository;

  GetShopUseCase(this.repository);

  @override
  Future<Either<Failure, List<ShopEntity>>> call(GetShopParams params) async {
    return await repository.getShops(
      token: params.token,
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class GetShopParams extends Equatable {
  final String token;
  final int? skip;
  final int? limit;

  const GetShopParams({
    required this.token,

    this.skip,
    this.limit,
  });

  @override
  List<Object?> get props => [token, skip, limit];
}