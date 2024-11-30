import 'package:either_dart/either.dart';

import '../../../../core/errors/failure.dart';
import '../entities/product/image_entity.dart';
import '../entities/product/product_entity.dart';
import '../entities/shop/analytic_product_entity.dart';
import '../entities/shop/analytic_shop_entity.dart';
import '../entities/shop/review_entity.dart';
import '../entities/shop/shop_entity.dart';
import '../entities/shop/working_hour_entity.dart';

abstract class ShopRepository {
  Future<Either<Failure, List<ShopEntity>>> getShop({
    required String token,
    String? search,
    List<String>? category,
    int? rating,
    int? verified,
    bool? active,
    String? ownerId,
    double? latitudes,
    double? longitudes,
    double? radiusInKilometers,
    String? condition,
    String? sortBy,
    String? sortOrder,
    int? skip = 0,
    int? limit = 15,
  });

  Future<Either<Failure, ShopEntity>> getShopById({
    required String id,
  });

  Future<Either<Failure, List<ImageEntity>>> getShopProductsImages({
    required String shopId,
    int? skip = 0,
    int? limit = 15,
  });

  Future<Either<Failure, List<String>>> getShopProductsVideos({
    required String shopId,
    int? skip = 0,
    int? limit = 15,
  });

  Future<Either<Failure, List<ReviewEntity>>> getShopReviews({
    required String shopId,
    String? userId,
    String? sortBy,
    String? sortOrder,
    int? rating,
    int? skip = 0,
    int? limit = 15,
  });

  Future<Either<Failure, List<ProductEntity>>> getShopProducts({
    required String token,
    required String shopId,
    String? sortBy,
    String? sortOrder,
    int? skip,
    int? limit,
  });

  Future<Either<Failure, List<ProductEntity>>> getFollowingShopProducts({
    required String token,
    int? skip,
    int? limit,
  });

  Future<Either<Failure, List<WorkingHourEntity>>> getShopWorkingHours({
    required String shopId,
  });

  Future<Either<Failure, ProductEntity>> addProduct({
    required String token,
    required String title,
    required String description,
    required int price,
    required bool isNew,
    required bool isDeliverable,
    required int availableQuantity,
    required bool isNegotiable,
    required bool inStock,
    required String shopId,
    required String status,
    required List<String> images,
    required List<String> colorIds,
    required List<String> sizeIds,
    required List<String> categoryIds,
    required List<String> brandIds,
    required List<String> materialIds,
    required List<String> designIds,
    String? videoUrl,
  });

  Future<Either<Failure, ImageEntity>> addProductImage({
    required String token,
    required String base64Image,
  });

  Future<Either<Failure, ProductEntity>> deleteProductById({
    required String token,
    required String productId,
  });
  Future<Either<Failure, String>> addOrRemoveFavorite(
      {required String token, required String productId});

  Future<Either<Failure, ProductEntity>> updateProduct({
    required String token,
    required String id,
    String? title,
    String? description,
    int? price,
    bool? isNew,
    bool? isDeliverable,
    int? availableQuantity,
    bool? isNegotiable,
    bool? inStock,
    String? shopId,
    String? status,
    List<String>? images,
    List<String>? colorIds,
    List<String>? sizeIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? materialIds,
    List<String>? designIds,
    String? videoUrl,
  });

  Future<Either<Failure, ReviewEntity>> addReview({
    required String token,
    required String shopId,
    required String review,
    required int rating,
  });

  Future<Either<Failure, ReviewEntity>> updateReview({
    required String token,
    required String reviewId,
    required String review,
    required int rating,
  });

  Future<Either<Failure, ReviewEntity>> deleteReview({
    required String token,
    required String reviewId,
  });

  Future<Either<Failure, AnalyticShopEntity>> getShopAnalytic({
    required String id,
    required String token,
  });

  Future<Either<Failure, ShopEntity>> createShop({
    required String token,
    required String name,
    required String description,
    required String street,
    required String subLocality,
    required String subAdministrativeArea,
    required String postalCode,
    required double latitude,
    required double longitude,
    required String phone,
    required String logo,
    required List<String> categories,
    required Map<String, String> socialMedia,
    String? website,
  });

  Future<Either<Failure, WorkingHourEntity>> addWorkingHour({
    required String token,
    required String shopId,
    required String day,
    required String time,
  });

  Future<Either<Failure, WorkingHourEntity>> updateWorkingHour({
    required String token,
    required String id,
    required String day,
    required String time,
  });

  Future<Either<Failure, ShopEntity>> updateShop({
    required String token,
    required String id,
    String? name,
    String? description,
    String? street,
    String? subLocality,
    String? subAdministrativeArea,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? banner,
    String? logo,
    List<String>? categories,
    Map<String, String>? socialMedia,
    String? website,
  });

  Future<Either<Failure, WorkingHourEntity>> deleteWorkingHour({
    required String token,
    required String id,
  });

  Future<Either<Failure, ShopEntity>> deleteShop({
    required String token,
    required String id,
  });

  Future<Either<Failure, AnalyticProductEntity>> getProductAnalytic({
    required String token,
    required String id,
  });

  Future<Either<Failure, bool>> followOrUnfollowShop({
    required String token,
    required String id,
  });

  Future<Either<Failure, String>> makeContact({
    required String token,
    required String id,
  });

  Future<Either<Failure, ProductEntity>> getProductById({
    required String id,
  });

  Future<Either<Failure, ShopEntity>> requestShopVerification({
    required String token,
    required String id,
    required String ownerIdentityCardUrl,
    required String businessRegistrationNumber,
    required String businessRegistrationDocumentUrl,
    required String ownerSelfieUrl,
  });
}
