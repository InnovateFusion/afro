import 'dart:io';

import 'package:either_dart/either.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/internet.dart';
import '../../domain/entities/product/brand_entity.dart';
import '../../domain/entities/product/category_entity.dart';
import '../../domain/entities/product/color_entity.dart';
import '../../domain/entities/product/design_entity.dart';
import '../../domain/entities/product/domain_entity.dart';
import '../../domain/entities/product/location_entity.dart';
import '../../domain/entities/product/material_entity.dart';
import '../../domain/entities/product/product_entity.dart';
import '../../domain/entities/product/size_entity.dart';
import '../../domain/repositories/product.dart';
import '../datasources/remote/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ColorEntity>>> getColors() async {
    if (await networkInfo.isConnected) {
      try {
        final colors = await remoteDataSource.getColors();
        return Right(colors);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands() async {
    if (await networkInfo.isConnected) {
      try {
        final brands = await remoteDataSource.getBrands();
        return Right(brands);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<MaterialEntity>>> getMaterials() async {
    if (await networkInfo.isConnected) {
      try {
        final materials = await remoteDataSource.getMaterials();
        return Right(materials);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SizeEntity>>> getSizes() async {
    if (await networkInfo.isConnected) {
      try {
        final sizes = await remoteDataSource.getSizes();
        return Right(sizes);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getLocations() async {
    if (await networkInfo.isConnected) {
      try {
        final locations = await remoteDataSource.getLocations();
        return Right(locations);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<DesignEntity>>> getDesigns() async {
    if (await networkInfo.isConnected) {
      try {
        final designs = await remoteDataSource.getDesigns();
        return Right(designs);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<DomainEntity>>> getDomains() async {
    if (await networkInfo.isConnected) {
      try {
        final domains = await remoteDataSource.getDomains();
        return Right(domains);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(
          search: search,
          colorIds: colorIds,
          sizeIds: sizeIds,
          categoryIds: categoryIds,
          brandIds: brandIds,
          materialIds: materialIds,
          designIds: designIds,
          isNegotiable: isNegotiable,
          isNew: isNew,
          isDeliverable: isDeliverable,
          minPrice: minPrice,
          maxPrice: maxPrice,
          inStock: inStock,
          shopId: shopId,
          status: status,
          latitudes: latitudes,
          longitudes: longitudes,
          radiusInKilometers: radiusInKilometers,
          condition: condition,
          sortBy: sortBy,
          sortOrder: sortOrder,
          skip: skip,
          limit: limit,
          token: token,
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
  Future<Either<Failure, List<ProductEntity>>> getFavoriteProducts(
      String token, int? skip, int? limit) async {
    if (await networkInfo.isConnected) {
      try {
        final products =
            await remoteDataSource.getFavoriteProducts(token, skip, limit);
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> shareProductToTikTok(
      {required String accessToken,
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
      required bool brandOrganicToggle}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.shareProductToTikTok(
          accessToken: accessToken,
          title: title,
          description: description,
          disableComments: disableComments,
          duetDisabled: duetDisabled,
          stitchDisabled: stitchDisabled,
          privcayLevel: privcayLevel,
          autoAddMusic: autoAddMusic,
          source: source,
          photoCoverIndex: photoCoverIndex,
          photoImages: photoImages,
          postMode: postMode,
          mediaType: mediaType,
          brandContentToggle: brandContentToggle,
          brandOrganicToggle: brandOrganicToggle,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, File>> removeBackground(
      {required String token, required File imageFile}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeBackground(
            token: token, imageFile: imageFile);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, File>> removeBackgroundFromUrl(
      {required String token, required String imageUrl}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeBackgroundFromUrl(
            token: token, imageUrl: imageUrl);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(CacheFailure(message: 'No internet connection'));
    }
  }
}
