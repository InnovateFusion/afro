import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../setUp/size/app_size.dart';
import 'category_chip.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.primaryContainer,
            highlightColor: Theme.of(context).colorScheme.onPrimary,
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(
                  left: AppSize.smallSize, right: AppSize.smallSize),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSize.mediumSize),
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSize.smallSize),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.mediumSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        highlightColor: Theme.of(context).colorScheme.onPrimary,
                        child: Container(
                          width: 150,
                          height: 20,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius:
                                BorderRadius.circular(AppSize.xSmallSize),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSize.smallSize),
                      Shimmer.fromColors(
                        baseColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        highlightColor: Theme.of(context).colorScheme.onPrimary,
                        child: Wrap(
                          spacing: AppSize.smallSize,
                          runSpacing: AppSize.smallSize,
                          children: List.generate(8, (index) {
                            return const CategoryChipShimmer();
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
