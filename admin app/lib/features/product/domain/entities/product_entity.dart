import 'package:equatable/equatable.dart';
import 'shop_info_entity.dart';

import 'brand_entity.dart';
import 'category_entity.dart';
import 'color_entity.dart';
import 'design_entity.dart';
import 'image_entity.dart';
import 'material_entity.dart';
import 'size_entity.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  final double price;
  final String status;
  final bool inStock;
  final bool isDeliverable;
  final int availableQuantity;
  final bool isNew;
  final String? videoUrl;
  final List<SizeEntity> sizes;
  final List<ColorEntity> colors;
  final List<MaterialEntity> materials;
  final List<CategoryEntity> categories;
  final List<ImageEntity> images;
  final List<BrandEntity> brands;
  final List<DesignEntity> designs;
  final ShopInfoEntity shopInfo;
  final bool isNegotiable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int productApprovalStatus;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.isFavorite,
    required this.description,
    required this.shopInfo,
    required this.price,
    required this.status,
    required this.inStock,
    required this.isDeliverable,
    required this.availableQuantity,
    required this.isNew,
    required this.sizes,
    required this.colors,
    required this.materials,
    required this.categories,
    required this.images,
    required this.brands,
    required this.designs,
    required this.isNegotiable,
    required this.createdAt,
    required this.updatedAt,
    required this.productApprovalStatus,
    this.videoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        status,
        inStock,
        isDeliverable,
        availableQuantity,
        isNew,
        shopInfo,
        sizes,
        colors,
        materials,
        isFavorite,
        isFavorite,
        categories,
        images,
        brands,
        designs,
        isNegotiable,
        productApprovalStatus,
        createdAt,
        updatedAt,
      ];

  ProductEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
    double? price,
    String? status,
    bool? inStock,
    bool? isDeliverable,
    int? availableQuantity,
    bool? isNew,
    String? videoUrl,
    List<SizeEntity>? sizes,
    List<ColorEntity>? colors,
    List<MaterialEntity>? materials,
    List<CategoryEntity>? categories,
    List<ImageEntity>? images,
    List<BrandEntity>? brands,
    List<DesignEntity>? designs,
    ShopInfoEntity? shopInfo,
    bool? isNegotiable,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productApprovalStatus,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      price: price ?? this.price,
      status: status ?? this.status,
      inStock: inStock ?? this.inStock,
      isDeliverable: isDeliverable ?? this.isDeliverable,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      isNew: isNew ?? this.isNew,
      videoUrl: videoUrl ?? this.videoUrl,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      materials: materials ?? this.materials,
      categories: categories ?? this.categories,
      images: images ?? this.images,
      brands: brands ?? this.brands,
      designs: designs ?? this.designs,
      shopInfo: shopInfo ?? this.shopInfo,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productApprovalStatus: productApprovalStatus ?? this.productApprovalStatus,
    );
  }
}
