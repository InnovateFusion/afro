import 'dart:convert';

import '../../../../core/errors/failure.dart';
import '../models/product_model.dart';
import '../../domain/entities/product_entity.dart';
import 'package:either_dart/either.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/network/internet.dart';
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
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      {required String token, int? skip = 0, int? limit = 15}) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(
          token: token,
          skip: skip,
          limit: limit,
        );
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> approvalReview(
      {required String token, required String id, required int status}) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.approvalReview(
          token: token,
          id: id,
          status: status,
        );
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addNewProduct(
      {required String product}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = ProductModel.fromJson(jsonDecode(product));
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
