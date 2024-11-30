import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../entities/shop/shop_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../repositories/shop.dart';

class CreateShopUseCase extends UseCase<ShopEntity, Params> {
  final ShopRepository repository;

  CreateShopUseCase(this.repository);

  @override
  Future<Either<Failure, ShopEntity>> call(Params params) async {
    return await repository.createShop(
      token: params.token,
      name: params.name,
      description: params.description,
      street: params.street,
      subLocality: params.subLocality,
      subAdministrativeArea: params.subAdministrativeArea,
      postalCode: params.postalCode,
      latitude: params.latitude,
      longitude: params.longitude,
      phone: params.phone,
      website: params.website,
      logo: params.logo,
      categories: params.categories,
      socialMedia: params.socialMedia,
    );
  }
}

class Params extends Equatable {
  final String token;
  final String name;
  final String description;
  final String street;
  final String subLocality;
  final String subAdministrativeArea;
  final String postalCode;
  final double latitude;
  final double longitude;
  final String phone;

  final String logo;
  final List<String> categories;
  final Map<String, String> socialMedia;
  final String? website;

  const Params({
    required this.token,
    required this.name,
    required this.description,
    required this.street,
    required this.subLocality,
    required this.subAdministrativeArea,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.logo,
    required this.categories,
    required this.socialMedia,
    this.website,
  });

  @override
  List<Object?> get props => [
        token,
        name,
        description,
        street,
        subLocality,
        subAdministrativeArea,
        postalCode,
        latitude,
        longitude,
        phone,
        website,
        logo,
        categories,
        socialMedia
      ];
}
