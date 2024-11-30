import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product.dart';

class ProductApprovalUseCase
    extends UseCase<ProductEntity, ProductApprovalParams> {
  final ProductRepository repository;

  ProductApprovalUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(
      ProductApprovalParams params) async {
    return await repository.approvalReview(
      token: params.token,
      id: params.id,
      status: params.status,
    );
  }
}

class ProductApprovalParams extends Equatable {
  final String token;
  final String id;
  final int status;

  const ProductApprovalParams({
    required this.token,
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [token, id, status];
}
