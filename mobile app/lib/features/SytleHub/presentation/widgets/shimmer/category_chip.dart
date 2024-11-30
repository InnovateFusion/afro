import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../setUp/size/app_size.dart';

class CategoryChipShimmer extends StatelessWidget {
  const CategoryChipShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 280) {
      width = (width - (16 * 3)) / 2;
    } else if (width <= 340) {
      width = (width - (16 * 4)) / 3;
    } else if (width <= 450) {
      width = (width - (16 * 5)) / 4;
    } else if (width <= 550) {
      width = (width - (16 * 6)) / 5;
    } else if (width <= 650) {
      width = (width - (16 * 7)) / 6;
    } else if (width <= 700) {
      width = (width - (16 * 8)) / 7;
    } else {
      width = 80;
    }

    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary,
      child: SizedBox(
        width: width,
        child: Column(
          children: <Widget>[
            Container(
              height: width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: width * 0.6,
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
