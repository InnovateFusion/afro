
import '../../../domain/entities/shop/analytic_shop_entity.dart';

class AnalyticShopModel extends AnalyticShopEntity {
  const AnalyticShopModel({
    required super.totalFollowers,
    required super.totalReviews,
    required super.totalFavorites,
    required super.totalProducts,
    required super.totalContacts,
    required super.totalViews,
    required super.oneStarReviews,
    required super.twoStarReviews,
    required super.threeStarReviews,
    required super.fourStarReviews,
    required super.fiveStarReviews,
  });

  factory AnalyticShopModel.fromJson(Map<String, dynamic> json) {
    return AnalyticShopModel(
      totalFollowers: json['totalFollowers'] as int,
      totalReviews: json['totalReviews'] as int,
      totalFavorites: json['totalFavorites'] as int,
      totalProducts: json['totalProducts'] as int,
      totalContacts: json['totalContacts'] as int,
      totalViews: json['totalViews'] as int,
      oneStarReviews: json['oneStarReviews'] as int,
      twoStarReviews: json['twoStarReviews'] as int,
      threeStarReviews: json['threeStarReviews'] as int,
      fourStarReviews: json['fourStarReviews'] as int,
      fiveStarReviews: json['fiveStarReviews'] as int,
    );
  }
}