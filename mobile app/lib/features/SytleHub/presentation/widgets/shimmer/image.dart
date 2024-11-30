import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../setUp/size/app_size.dart';

class ImageShimmer extends StatelessWidget {
  const ImageShimmer({
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

    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
          ),
        ),
      ),
    );
  }
}
