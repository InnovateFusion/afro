import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class AddOrRemoveFavoriteUseCase extends UseCase<String, Params> {
  final ShopRepository repository;

  AddOrRemoveFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await repository.addOrRemoveFavorite(
      token: params.token,
      productId: params.productId,
    );
  }
}

class Params extends Equatable {
  final String token;
  final String productId;

  const Params({
    required this.token,
    required this.productId,
  });

  @override
  List<Object> get props => [token, productId];
}
