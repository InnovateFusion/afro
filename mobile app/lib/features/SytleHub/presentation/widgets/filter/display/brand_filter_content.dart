import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/captilizations.dart';
import '../../../../../../setUp/language/translation_map.dart';
import '../../../../../../setUp/size/app_size.dart';
import '../../../bloc/product_filter/product_filter_bloc.dart';
import '../../../bloc/product/product_bloc.dart';

class BrandFilterContent extends StatelessWidget {
  const BrandFilterContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSize.smallSize,
      children: [
        if (context.watch<ProductBloc>().state.brandStatus ==
            BrandStatus.success)
          for (int index = 0;
              index <
                  min(
                    8,
                    context.watch<ProductBloc>().state.brands.length,
                  );
              index++)
            Container(
              margin: const EdgeInsets.only(top: AppSize.smallSize),
              child: Column(
                children: [
                  (context
                          .watch<ProductFilterBloc>()
                          .state
                          .selectedBrands
                          .contains(context
                              .watch<ProductBloc>()
                              .state
                              .brands[index]
                              .id))
                      ? GestureDetector(
                          onTap: () {
                            final brandId = context
                                .read<ProductBloc>()
                                .state
                                .brands[index]
                                .id;
                            context
                                .read<ProductFilterBloc>()
                                .add(RemoveSelectedBrandEvent(brandId));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.xxSmallSize),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xxSmallSize),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            child: Text(
                              Captilizations.capitalize(
                                  LocalizationMap.getBrandMap(
                                      context,
                                      context
                                          .watch<ProductBloc>()
                                          .state
                                          .brands[index]
                                          .name)),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            final brandId = context
                                .read<ProductBloc>()
                                .state
                                .brands[index]
                                .id;
                            context
                                .read<ProductFilterBloc>()
                                .add(AddSelectedBrandEvent(brandId));
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.smallSize,
                                  vertical: AppSize.xxSmallSize),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppSize.xxSmallSize),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh,
                                ),
                              ),
                              child: Text(
                                Captilizations.capitalize(
                                    LocalizationMap.getBrandMap(
                                        context,
                                        context
                                            .watch<ProductBloc>()
                                            .state
                                            .brands[index]
                                            .name)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              )),
                        ),
                ],
              ),
            ),
        const SizedBox(height: AppSize.smallSize),
      ],
    );
  }
}
