import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../setUp/size/app_size.dart';

class MyShopAnalyticShimmer extends StatelessWidget {
  const MyShopAnalyticShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AnalyticsCardShimmer(),
        SizedBox(height: AppSize.mediumSize),
        _RatingOverviewShimmer(),
      ],
    );
  }
}

class _AnalyticsCardShimmer extends StatelessWidget {
  const _AnalyticsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerContainer(height: 20, width: 120),
          SizedBox(height: AppSize.smallSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AnalyticsItemShimmer(),
              SizedBox(width: AppSize.smallSize),
              _AnalyticsItemShimmer(),
            ],
          ),
          SizedBox(height: AppSize.smallSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AnalyticsItemShimmer(),
              SizedBox(width: AppSize.smallSize),
              _AnalyticsItemShimmer(),
            ],
          ),
          SizedBox(height: AppSize.smallSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AnalyticsItemShimmer(),
              SizedBox(width: AppSize.smallSize),
              _AnalyticsItemShimmer(),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsItemShimmer extends StatelessWidget {
  const _AnalyticsItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSize.xSmallSize),
        ),
      ),
    );
  }
}

class _RatingOverviewShimmer extends StatelessWidget {
  const _RatingOverviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerContainer(height: 20, width: 100),
          SizedBox(height: AppSize.mediumSize),
          _ShimmerContainer(height: 150, width: double.infinity),
        ],
      ),
    );
  }
}

class _ShimmerContainer extends StatelessWidget {
  final double height;
  final double width;

  const _ShimmerContainer({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
      ),
    );
  }
}
