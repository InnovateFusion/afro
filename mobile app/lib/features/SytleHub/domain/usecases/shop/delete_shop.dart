import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/shop/shop_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class DeleteShopUseCase extends UseCase<ShopEntity, Params> {
  final ShopRepository repository;

  DeleteShopUseCase(this.repository);

  @override
  Future<Either<Failure, ShopEntity>> call(Params params) async {
    return await repository.deleteShop(
      id: params.id,
      token: params.token,
    );
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
  List<Object?> get props => [
        token,
        id,
      ];
}
