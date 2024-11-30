import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class FollowUnfollowShopUseCase extends UseCase<bool, FollowUnfollowShopParams> {
  final ShopRepository repository;

  FollowUnfollowShopUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(FollowUnfollowShopParams params) async {
    return await repository.followOrUnfollowShop(
      id: params.shopId,
      token: params.token,
    );
  }
}

class FollowUnfollowShopParams extends Equatable {
  final String shopId;
  final String token;

  const FollowUnfollowShopParams({
    required this.shopId,
    required this.token,
  });

  @override
  List<Object> get props => [shopId, token];
}
