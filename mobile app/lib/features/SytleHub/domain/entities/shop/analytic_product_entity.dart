import 'package:equatable/equatable.dart';

class AnalyticProductEntity extends Equatable {
  final int totalViews;
  final int todayViews;
  final int totalFavorites;
  final int totalContacted;

  final Map<String, int> thisMonthViews;
  final Map<String, int> thisWeekViews;
  final Map<String, int> thisYearViews;

  const AnalyticProductEntity({
    required this.totalViews,
    required this.todayViews,
    required this.totalFavorites,
    required this.totalContacted,
    required this.thisMonthViews,
    required this.thisWeekViews,
    required this.thisYearViews,
  });

  @override
  List<Object> get props => [
        totalViews,
        todayViews,
        totalFavorites,
        totalContacted,
        thisMonthViews,
        thisWeekViews,
        thisYearViews,
      ];

  AnalyticProductEntity copyWith({
    int? totalViews,
    int? todayViews,
    int? totalFavorites,
    int? totalContacted,
    Map<String, int>? thisMonthViews,
    Map<String, int>? thisWeekViews,
    Map<String, int>? thisYearViews,
  }) {
    return AnalyticProductEntity(
      totalViews: totalViews ?? this.totalViews,
      todayViews: todayViews ?? this.todayViews,
      totalFavorites: totalFavorites ?? this.totalFavorites,
      totalContacted: totalContacted ?? this.totalContacted,
      thisMonthViews: thisMonthViews ?? this.thisMonthViews,
      thisWeekViews: thisWeekViews ?? this.thisWeekViews,
      thisYearViews: thisYearViews ?? this.thisYearViews,
    );
  }
}
