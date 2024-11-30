import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/product.dart';

class GetProductsUseCase extends UseCase<List<ProductEntity>, Params> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(Params params) async {
    return await repository.getProducts(
      token: params.token,
      search: params.search,
      colorIds: params.colorIds,
      sizeIds: params.sizeIds,
      categoryIds: params.categoryIds,
      designIds: params.designIds,
      brandIds: params.brandIds,
      materialIds: params.materialIds,
      isNegotiable: params.isNegotiable,
      inStock: params.inStock,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      shopId: params.shopId,
      status: params.status,
      latitudes: params.latitudes,
      longitudes: params.longitudes,
      radiusInKilometers: params.radiusInKilometers,
      condition: params.condition,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
      skip: params.skip,
      limit: params.limit,
    );
  }
}

class Params extends Equatable {
  final String token;
  final String? search;
  final List<String>? colorIds;
  final List<String>? sizeIds;
  final List<String>? categoryIds;
  final List<String>? brandIds;
  final List<String>? materialIds;
  final List<String>? designIds;
  final bool? isNegotiable;
  final bool? isDeliverable;
  final bool? inStock;
  final bool? isNew;
  final double? minPrice;
  final double? maxPrice;
  final String? shopId;
  final String? status;
  final double? latitudes;
  final double? longitudes;
  final double? radiusInKilometers;
  final String? condition;
  final String? sortBy;
  final String? sortOrder;
  final int? skip;
  final int? limit;

  const Params({
    required this.token,
    this.search,
    this.colorIds,
    this.sizeIds,
    this.categoryIds,
    this.brandIds,
    this.designIds,
    this.materialIds,
    this.isNegotiable,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.isNew,
    this.isDeliverable,
    this.shopId,
    this.status,
    this.latitudes,
    this.longitudes,
    this.radiusInKilometers,
    this.condition,
    this.sortBy,
    this.sortOrder,
    this.skip,
    this.limit,
  });

  @override
  List<Object?> get props => [
        search,
        colorIds,
        sizeIds,
        categoryIds,
        brandIds,
        materialIds,
        isNegotiable,
        isNew,
        isDeliverable,
        minPrice,
        maxPrice,
        designIds,
        inStock,
        shopId,
        status,
        latitudes,
        longitudes,
        radiusInKilometers,
        condition,
        sortBy,
        sortOrder,
        token,
      ];
}
