import 'package:either_dart/either.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/internet.dart';
import '../../domain/entities/product/image_entity.dart';
import '../../domain/entities/product/product_entity.dart';
import '../../domain/entities/shop/analytic_product_entity.dart';
import '../../domain/entities/shop/analytic_shop_entity.dart';
import '../../domain/entities/shop/review_entity.dart';
import '../../domain/entities/shop/shop_entity.dart';
import '../../domain/entities/shop/working_hour_entity.dart';
import '../../domain/repositories/shop.dart';
import '../datasources/remote/shop.dart';

class ShopRepositoryImpl extends ShopRepository {
  final ShopRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ShopRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ShopEntity>>> getShop(
      {required String token,
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
      int? limit = 15}) async {
    if (await networkInfo.isConnected) {
      try {
        final shops = await remoteDataSource.getShop(
          token: token,
          search: search,
          category: category,
          rating: rating,
          verified: verified,
          active: active,
          ownerId: ownerId,
          latitudes: latitudes,
          longitudes: longitudes,
          radiusInKilometers: radiusInKilometers,
          condition: condition,
          sortBy: sortBy,
          sortOrder: sortOrder,
          skip: skip,
          limit: limit,
        );
        return Right(shops);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ShopEntity>> getShopById({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final shop = await remoteDataSource.getShopById(id: id);
        return Right(shop);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getShopProducts(
      {required String token,
      required String shopId,
      String? sortBy,
      String? sortOrder,
      int? skip,
      int? limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getShopProducts(
          token: token,
          shopId: shopId,
          sortBy: sortBy,
          sortOrder: sortOrder,
          skip: skip,
          limit: limit,
        );
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ImageEntity>>> getShopProductsImages(
      {required String shopId, int? skip = 0, int? limit = 15}) async {
    if (await networkInfo.isConnected) {
      try {
        final images = await remoteDataSource.getShopProductsImages(
          shopId: shopId,
          skip: skip,
          limit: limit,
        );
        return Right(images);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getShopProductsVideos(
      {required String shopId, int? skip = 0, int? limit = 15}) async {
    if (await networkInfo.isConnected) {
      try {
        final videos = await remoteDataSource.getShopProductsVideos(
          shopId: shopId,
          skip: skip,
          limit: limit,
        );
        return Right(videos);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getShopReviews(
      {required String shopId,
      String? userId,
      String? sortBy,
      String? sortOrder,
      int? rating,
      int? skip = 0,
      int? limit = 15}) async {
    if (await networkInfo.isConnected) {
      try {
        final reviews = await remoteDataSource.getShopReviews(
          shopId: shopId,
          userId: userId,
          sortBy: sortBy,
          sortOrder: sortOrder,
          rating: rating,
          skip: skip,
          limit: limit,
        );
        return Right(reviews);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<WorkingHourEntity>>> getShopWorkingHours(
      {required String shopId}) async {
    if (await networkInfo.isConnected) {
      try {
        final workingHours = await remoteDataSource.getShopWorkingHours(
          shopId: shopId,
        );
        return Right(workingHours);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addProduct(
      {required String token,
      required String title,
      required String description,
      required int price,
      required bool inStock,
      required bool isNew,
      required bool isDeliverable,
      required int availableQuantity,
      required bool isNegotiable,
      required String shopId,
      required String status,
      required List<String> images,
      required List<String> colorIds,
      required List<String> sizeIds,
      required List<String> categoryIds,
      required List<String> brandIds,
      required List<String> materialIds,
      required List<String> designIds,
      String? videoUrl}) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.addProduct(
          token: token,
          title: title,
          description: description,
          price: price,
          isNew: isNew,
          isDeliverable: isDeliverable,
          availableQuantity: availableQuantity,
          isNegotiable: isNegotiable,
          inStock: inStock,
          shopId: shopId,
          status: status,
          images: images,
          colorIds: colorIds,
          sizeIds: sizeIds,
          categoryIds: categoryIds,
          brandIds: brandIds,
          materialIds: materialIds,
          designIds: designIds,
          videoUrl: videoUrl,
        );
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ImageEntity>> addProductImage(
      {required String token, required String base64Image}) async {
    if (await networkInfo.isConnected) {
      try {
        final image = await remoteDataSource.addProductImage(
          token: token,
          base64Image: base64Image,
        );
        return Right(image);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> deleteProductById(
      {required String token, required String productId}) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.deleteProductById(
          token: token,
          productId: productId,
        );
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> addOrRemoveFavorite(
      {required String token, required String productId}) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.addOrRemoveProductFromFavorite(
          token: token,
          productId: productId,
        );
        return Right(message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(
      {   required String token,
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
      String? videoUrl}) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.updateProduct(
          token: token,
          id: id,
          title: title,
          description: description,
          price: price,
          isNew: isNew,
          isDeliverable: isDeliverable,
          availableQuantity: availableQuantity,
          isNegotiable: isNegotiable,
          shopId: shopId,
          inStock: inStock,
          status: status,
          images: images,
          colorIds: colorIds,
          sizeIds: sizeIds,
          categoryIds: categoryIds,
          brandIds: brandIds,
          materialIds: materialIds,
          designIds: designIds,
          videoUrl: videoUrl,
        );
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> addReview({
    required String token,
    required String shopId,
    required String review,
    required int rating,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final reviewData = await remoteDataSource.addReview(
          token: token,
          shopId: shopId,
          review: review,
          rating: rating,
        );
        return Right(reviewData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> updateReview({
    required String token,
    required String reviewId,
    required String review,
    required int rating,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final reviewData = await remoteDataSource.updateReview(
          token: token,
          reviewId: reviewId,
          review: review,
          rating: rating,
        );
        return Right(reviewData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> deleteReview(
      {required String token, required String reviewId}) async {
    if (await networkInfo.isConnected) {
      try {
        final reviewData = await remoteDataSource.deleteReview(
          token: token,
          reviewId: reviewId,
        );
        return Right(reviewData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AnalyticShopEntity>> getShopAnalytic(
      {required String id, required String token}) async {
    if (await networkInfo.isConnected) {
      try {
        final shopAnalytic =
            await remoteDataSource.getShopAnalytic(id: id, token: token);
        return Right(shopAnalytic);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final shop = await remoteDataSource.createShop(
          token: token,
          name: name,
          description: description,
          street: street,
          subLocality: subLocality,
          subAdministrativeArea: subAdministrativeArea,
          postalCode: postalCode,
          latitude: latitude,
          longitude: longitude,
          phone: phone,
          website: website,
          logo: logo,
          categories: categories,
          socialMedia: socialMedia,
        );
        return Right(shop);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, WorkingHourEntity>> addWorkingHour(
      {required String token,
      required String shopId,
      required String day,
      required String time}) async {
    if (await networkInfo.isConnected) {
      try {
        final workingHour = await remoteDataSource.addWorkingHour(
          token: token,
          shopId: shopId,
          day: day,
          time: time,
        );
        return Right(workingHour);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ShopEntity>> updateShop(
      {required String token,
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
      String? website}) async {
    if (await networkInfo.isConnected) {
      try {
        final shop = await remoteDataSource.updateShop(
          token: token,
          id: id,
          name: name,
          description: description,
          street: street,
          subLocality: subLocality,
          subAdministrativeArea: subAdministrativeArea,
          postalCode: postalCode,
          latitude: latitude,
          longitude: longitude,
          phone: phone,
          banner: banner,
          logo: logo,
          categories: categories,
          socialMedia: socialMedia,
          website: website,
        );
        return Right(shop);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, WorkingHourEntity>> updateWorkingHour(
      {required String token,
      required String id,
      required String day,
      required String time}) async {
    if (await networkInfo.isConnected) {
      try {
        final workingHour = await remoteDataSource.updateWorkingHour(
          token: token,
          id: id,
          day: day,
          time: time,
        );
        return Right(workingHour);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, WorkingHourEntity>> deleteWorkingHour(
      {required String token, required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final workingHour = await remoteDataSource.deleteWorkingHour(
          token: token,
          id: id,
        );
        return Right(workingHour);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ShopEntity>> deleteShop(
      {required String token, required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final shop = await remoteDataSource.deleteShop(
          token: token,
          id: id,
        );
        return Right(shop);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AnalyticProductEntity>> getProductAnalytic(
      {required String token, required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final analyticProduct = await remoteDataSource.getProductAnalytic(
          token: token,
          id: id,
        );
        return Right(analyticProduct);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> followOrUnfollowShop(
      {required String token, required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.followOrUnfollowShop(
          token: token,
          id: id,
        );
        return Right(message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> makeContact(
      {required String token, required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final message = await remoteDataSource.makeContact(
          token: token,
          id: id,
        );
        return Right(message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFollowingShopProducts(
      {required String token, int? skip, int? limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getFollowingShopProducts(
          token: token,
          skip: skip,
          limit: limit,
        );
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(
      {required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final product =
            await remoteDataSource.getShopProductsById(productId: id);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ShopEntity>> requestShopVerification(
      {required String token,
      required String id,
      required String ownerIdentityCardUrl,
      required String businessRegistrationNumber,
      required String businessRegistrationDocumentUrl,
      required String ownerSelfieUrl}) async {
    if (await networkInfo.isConnected) {
      try {
        final shop = await remoteDataSource.requestShopVerification(
          token: token,
          id: id,
          ownerIdentityCardUrl: ownerIdentityCardUrl,
          businessRegistrationNumber: businessRegistrationNumber,
          businessRegistrationDocumentUrl: businessRegistrationDocumentUrl,
          ownerSelfieUrl: ownerSelfieUrl,
        );
        return Right(shop);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }
}
