import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../setUp/size/app_size.dart';

class ShopShimmer extends StatelessWidget {
  const ShopShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 340) {
    } else if (width <= 500) {
      width = (width - (16 * 3)) / 2;
    } else if (width <= 700) {
      width = (width - (16 * 4)) / 3;
    } else if (width <= 900) {
      width = (width - (16 * 5)) / 4;
    } else if (width <= 1100) {
      width = (width - (16 * 6)) / 5;
    } else if (width <= 1100) {
      width = (width - (16 * 7)) / 6;
    } else if (width <= 1400) {
      width = (width - (16 * 8)) / 7;
    } else {
      width = (width - (16 * 9)) / 8;
    }

    final random = Random();
    final randomWidthFactor = 0.2 + random.nextDouble() * 0.4;

    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: width * 0.65,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.smallSize),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: width * 0.7,
              height: 16,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: width * 0.4,
              height: 16,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: width * randomWidthFactor,
              height: 12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
