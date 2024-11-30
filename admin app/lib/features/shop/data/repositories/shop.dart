import 'package:either_dart/either.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/internet.dart';
import '../../domain/entities/shop_entity.dart';
import '../../domain/repositories/shop.dart';
import '../datasources/remote/shop.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ShopRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ShopEntity>>> getShops(
      {required String token, int? skip = 0, int? limit = 15}) async {
    if (await networkInfo.isConnected) {
      try {
        final Shops = await remoteDataSource.getShops(
          token: token,
          skip: skip,
          limit: limit,
        );
        return Right(Shops);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
