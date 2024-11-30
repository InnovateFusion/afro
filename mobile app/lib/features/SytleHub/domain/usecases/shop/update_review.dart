import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/use_cases/usecase.dart';
import '../../entities/shop/review_entity.dart';
import '../../repositories/shop.dart';

class UpdateReviewUseCase extends   UseCase<ReviewEntity, Params> {
  final ShopRepository shopRepository;

  UpdateReviewUseCase(this.shopRepository);

  @override
  Future<Either<Failure, ReviewEntity>> call(Params params) async {
    return await shopRepository.updateReview(
      token: params.token,
      reviewId: params.reviewId,
      review: params.review,
      rating: params.rating,
    );
  }
}

class Params extends Equatable {
  final String token;
  final String reviewId;
  final String review;
  final int rating;

  const Params({
    required this.token,
    required this.reviewId,
    required this.review,
    required this.rating,
  });

  @override
  List<Object?> get props => [token, reviewId, review, rating];
}
