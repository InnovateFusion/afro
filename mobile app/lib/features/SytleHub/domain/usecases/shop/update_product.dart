import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/product/product_entity.dart';
import '../../repositories/shop.dart';

class UpdateProductsUseCase extends UseCase<ProductEntity, Params> {
  final ShopRepository repository;

  UpdateProductsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(Params params) async {
    return await repository.updateProduct(
        id: params.id,
        token: params.token,
        title: params.title,
        description: params.description,
        price: params.price,
        availableQuantity: params.availableQuantity,
        isNew: params.isNew,
        isNegotiable: params.isNegotiable,
        isDeliverable: params.isDeliverable,
        inStock: params.inStock,
        shopId: params.shopId,
        status: params.status,
        images: params.images,
        colorIds: params.colorIds,
        sizeIds: params.sizeIds,
        categoryIds: params.categoryIds,
        brandIds: params.brandIds,
        materialIds: params.materialIds,
        designIds: params.designIds,
        videoUrl: params.videoUrl);
  }
}

class Params extends Equatable {
  final String id;
  final String token;
  final String? title;
  final String? description;
  final int? price;
  final bool? inStock;
  final bool? isNew;
  final String? videoUrl;
  final bool? isNegotiable;
  final bool? isDeliverable;
  final int? availableQuantity;
  final String? status;
  final String? shopId;
  final List<String>? images;
  final List<String>? colorIds;
  final List<String>? sizeIds;
  final List<String>? categoryIds;
  final List<String>? brandIds;
  final List<String>? materialIds;
  final List<String>? designIds;

  const Params({
    required this.id,
    required this.token,
    this.title,
    this.description,
    this.price,
    this.inStock,
    this.isNew,
    this.videoUrl,
    this.isNegotiable,
    this.isDeliverable,
    this.availableQuantity,
    this.status,
    this.shopId,
    this.images,
    this.colorIds,
    this.sizeIds,
    this.categoryIds,
    this.brandIds,
    this.materialIds,
    this.designIds,
  });

  @override
  List<Object?> get props => [
        token,
        title,
        description,
        price,
        isNew,
        videoUrl,
        isNegotiable,
        isDeliverable,
        availableQuantity,
        inStock,
        status,
        images,
        shopId,
        colorIds,
        sizeIds,
        categoryIds,
        brandIds,
        materialIds,
        designIds
      ];
}
