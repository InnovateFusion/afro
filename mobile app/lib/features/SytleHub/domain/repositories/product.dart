import 'dart:io';

import 'package:either_dart/either.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product/brand_entity.dart';
import '../entities/product/category_entity.dart';
import '../entities/product/color_entity.dart';
import '../entities/product/design_entity.dart';
import '../entities/product/domain_entity.dart';
import '../entities/product/location_entity.dart';
import '../entities/product/material_entity.dart';
import '../entities/product/product_entity.dart';
import '../entities/product/size_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ColorEntity>>> getColors();
  Future<Either<Failure, List<BrandEntity>>> getBrands();
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<SizeEntity>>> getSizes();
  Future<Either<Failure, List<MaterialEntity>>> getMaterials();
  Future<Either<Failure, List<LocationEntity>>> getLocations();
  Future<Either<Failure, List<DesignEntity>>> getDesigns();
  Future<Either<Failure, List<DomainEntity>>> getDomains();
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required String token,
    String? search,
    List<String>? colorIds,
    List<String>? sizeIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? materialIds,
    List<String>? designIds,
    bool? isNegotiable,
    bool? inStock,
    bool? isNew,
    bool? isDeliverable,
    double? minPrice,
    double? maxPrice,
    String? shopId,
    String? status,
    double? latitudes,
    double? longitudes,
    double? radiusInKilometers,
    String? condition,
    String? sortBy,
    String? sortOrder,
    int? skip = 0,
    int? limit = 15,
  });
  Future<Either<Failure, List<ProductEntity>>> getFavoriteProducts(
      String token, int? skip, int? limit);

  Future<Either<Failure, bool>> shareProductToTikTok({
    required String accessToken,
    required String title,
    required String description,
    required bool disableComments,
    required bool duetDisabled,
    required bool stitchDisabled,
    required String privcayLevel,
    required bool autoAddMusic,
    required String source,
    required int photoCoverIndex,
    required List<String> photoImages,
    required String postMode,
    required String mediaType,
    required bool brandContentToggle,
    required bool brandOrganicToggle,
  });

  Future<Either<Failure, File>> removeBackground(
      {required String token, required File imageFile});

  Future<Either<Failure, File>> removeBackgroundFromUrl(
      {required String token, required String imageUrl});
}
