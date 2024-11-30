import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/shop/review_entity.dart';
import '../../repositories/shop.dart';

class DeleteReviewUseCase extends UseCase<ReviewEntity, Params> {
  final ShopRepository repository;

  DeleteReviewUseCase(this.repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(Params params) async {
    return await repository.deleteReview(
      reviewId: params.id,
      token: params.token,
    );
  }
}

class Params extends Equatable {
  final String id;
  final String token;

  const Params({
    required this.id,
    required this.token,
  });

  @override
  List<Object?> get props => [
        token,
        id,
      ];
}
