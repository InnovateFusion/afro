import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/shop/shop_entity.dart';
import '../../repositories/shop.dart';

class UpdateShopUseCase extends UseCase<ShopEntity, Params> {
  final ShopRepository repository;

  UpdateShopUseCase(this.repository);

  @override
  Future<Either<Failure, ShopEntity>> call(Params params) async {
    return await repository.updateShop(
      id: params.id,
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
      banner: params.banner,
      logo: params.logo,
      categories: params.categories,
      socialMedia: params.socialMedia,
      website: params.website,
    );
  }
}

class Params extends Equatable {
  final String id;
  final String token;
  final String? name;
  final String? description;
  final String? street;
  final String? subLocality;
  final String? subAdministrativeArea;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? banner;
  final String? logo;
  final List<String>? categories;
  final Map<String, String>? socialMedia;
  final String? website;

  const Params( {
    required this.id,
    required this.token,
    this.name,
    this.description,
    this.street,
    this.subLocality,
    this.subAdministrativeArea,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.banner,
    this.logo,
    this.categories,
    this.socialMedia,
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
