import '../../../domain/entities/shop/analytic_product_entity.dart';

class AnalyticProductModel extends AnalyticProductEntity {
  const AnalyticProductModel(
      {required super.totalViews,
      required super.todayViews,
      required super.totalFavorites,
      required super.totalContacted,
      required super.thisMonthViews,
      required super.thisWeekViews,
      required super.thisYearViews});

  factory AnalyticProductModel.fromJson(Map<String, dynamic> json) {
    return AnalyticProductModel(
      totalViews: json['totalViews'],
      todayViews: json['todayViews'],
      totalFavorites: json['totalFavorites'],
      totalContacted: json['totalContacted'],
      thisMonthViews: Map<String, int>.from(json['thisMonthViews']),
      thisWeekViews: Map<String, int>.from(json['thisWeekViews']),
      thisYearViews: Map<String, int>.from(json['thisYearViews']),
    );
  }
}
