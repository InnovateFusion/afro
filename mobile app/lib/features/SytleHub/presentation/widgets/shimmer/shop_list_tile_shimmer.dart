import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../setUp/size/app_size.dart';

class ShopListTileShimmer extends StatelessWidget {
  const ShopListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        title: Container(
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSize.xxSmallSize),
            Container(
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              width: 160,
            ),
            const SizedBox(height: AppSize.xxSmallSize),
            Container(
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              width: 120,
            ),
          ],
        ),
      ),
    );
  }
}
