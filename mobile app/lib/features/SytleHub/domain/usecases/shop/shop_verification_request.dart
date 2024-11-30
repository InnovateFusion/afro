import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/shop/shop_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class ShopVerificationRequestUsecase extends UseCase<ShopEntity, Params> {
  final ShopRepository repository;

  ShopVerificationRequestUsecase(this.repository);

  @override
  Future<Either<Failure, ShopEntity>> call(Params params) async {
    return await repository.requestShopVerification(
      id: params.id,
      token: params.token,
      ownerIdentityCardUrl: params.ownerIdentityCardUrl,
      businessRegistrationNumber: params.businessRegistrationNumber,
      businessRegistrationDocumentUrl: params.businessRegistrationDocumentUrl,
      ownerSelfieUrl: params.ownerSelfieUrl,
    );
  }
}

class Params extends Equatable {
  final String id;
  final String token;
  final String ownerIdentityCardUrl;
  final String businessRegistrationNumber;
  final String businessRegistrationDocumentUrl;
  final String ownerSelfieUrl;

  const Params({
    required this.id,
    required this.token,
    required this.ownerIdentityCardUrl,
    required this.businessRegistrationNumber,
    required this.businessRegistrationDocumentUrl,
    required this.ownerSelfieUrl,
  });

  @override
  List<Object> get props => [
        id,
        token,
        ownerIdentityCardUrl,
        businessRegistrationNumber,
        businessRegistrationDocumentUrl,
        ownerSelfieUrl
      ];
}
