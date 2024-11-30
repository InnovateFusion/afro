import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/shop/review_entity.dart';
import '../../repositories/shop.dart';

import '../../../../../core/use_cases/usecase.dart';

class AddReviewUseCase extends UseCase<ReviewEntity, Params> {
  final ShopRepository shopRepository;

  AddReviewUseCase(this.shopRepository);

  @override
  Future<Either<Failure, ReviewEntity>> call(Params params) async {
    return await shopRepository.addReview(
      token: params.token,
      shopId: params.shopId,
      review: params.review,
      rating: params.rating,
    );
  }
}

class Params extends Equatable {
  final String token;
  final String shopId;
  final String review;
  final int rating;

 const Params({
    required this.token,
    required this.shopId,
    required this.review,
    required this.rating,
  });

  @override
  List<Object> get props => [token, shopId, review, rating];
}
