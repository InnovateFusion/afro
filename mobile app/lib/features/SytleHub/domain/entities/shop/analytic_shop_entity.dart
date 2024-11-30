import 'package:equatable/equatable.dart';

class AnalyticShopEntity extends Equatable {
  final int totalFollowers;
  final int totalReviews;
  final int totalFavorites;
  final int totalProducts;
  final int totalContacts;
  final int totalViews;
  final int oneStarReviews;
  final int twoStarReviews;
  final int threeStarReviews;
  final int fourStarReviews;
  final int fiveStarReviews;


  const AnalyticShopEntity({
    required this.totalFollowers,
    required this.totalReviews,
    required this.totalFavorites,
    required this.totalProducts,
    required this.totalContacts,
    required this.totalViews,
    required this.oneStarReviews,
    required this.twoStarReviews,
    required this.threeStarReviews,
    required this.fourStarReviews,
    required this.fiveStarReviews,
  });

  @override
  List<Object> get props => [
        totalFollowers,
        totalReviews,
        totalFavorites,
        totalProducts,
        totalContacts,
        totalViews,
        oneStarReviews,
        twoStarReviews,
        threeStarReviews,
        fourStarReviews,
        fiveStarReviews,
      ];

  AnalyticShopEntity copyWith({
    int? totalFollowers,
    int? totalReviews,
    int? totalFavorites,
    int? totalProducts,
    int? totalContacts,
    int? totalViews,
    int? oneStarReviews,
    int? twoStarReviews,
    int? threeStarReviews,
    int? fourStarReviews,
    int? fiveStarReviews,
  }) {
    return AnalyticShopEntity(
      totalFollowers: totalFollowers ?? this.totalFollowers,
      totalReviews: totalReviews ?? this.totalReviews,
      totalFavorites: totalFavorites ?? this.totalFavorites,
      totalProducts: totalProducts ?? this.totalProducts,
      totalContacts: totalContacts ?? this.totalContacts,
      totalViews: totalViews ?? this.totalViews,
      oneStarReviews: oneStarReviews ?? this.oneStarReviews,
      twoStarReviews: twoStarReviews ?? this.twoStarReviews,
      threeStarReviews: threeStarReviews ?? this.threeStarReviews,
      fourStarReviews: fourStarReviews ?? this.fourStarReviews,
      fiveStarReviews: fiveStarReviews ?? this.fiveStarReviews,
    );
  }
}
