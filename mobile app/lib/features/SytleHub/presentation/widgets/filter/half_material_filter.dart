import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/language/translation_map.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/product_filter/product_filter_bloc.dart';
import '../shimmer/filter.dart';
import 'bottom_filter_bar.dart';

class HalfMaterialFilterDisplay extends StatelessWidget {
  const HalfMaterialFilterDisplay(
      {super.key, required this.isAdd, required this.onTap});

  final bool isAdd;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: AppSize.smallSize,
                bottom: AppSize.xSmallSize,
                right: AppSize.smallSize,
                top: AppSize.xSmallSize),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context)!.filter_material}${context.watch<ProductFilterBloc>().state.selectedMaterials.isEmpty ? '' : ' (${context.watch<ProductFilterBloc>().state.selectedMaterials.length})'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSize.xxSmallSize),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.mediumSize),
                      border: Border.all(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (context.watch<ProductBloc>().state.materialStatus ==
              MaterialStatus.loading)
            const SizedBox(height: AppSize.largeSize),
          if (context.watch<ProductBloc>().state.materialStatus ==
              MaterialStatus.loading)
            for (int index = 0; index < 6; index++)
              Container(
                  margin: const EdgeInsets.only(bottom: AppSize.smallSize),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
                  child: const FilterShimmer()),
          Padding(
            padding: const EdgeInsets.only(
                bottom: AppSize.smallSize,
                left: AppSize.smallSize,
                right: AppSize.smallSize),
            child: Wrap(
              spacing: AppSize.smallSize,
              children: [
                if (context.watch<ProductBloc>().state.materialStatus ==
                    MaterialStatus.success)
                  for (int index = 0;
                      index <
                          min(
                            24,
                            context.watch<ProductBloc>().state.materials.length,
                          );
                      index++)
                    Container(
                      margin: const EdgeInsets.only(top: AppSize.smallSize),
                      child: Column(
                        children: [
                          (context
                                  .watch<ProductFilterBloc>()
                                  .state
                                  .selectedMaterials
                                  .contains(context
                                      .watch<ProductBloc>()
                                      .state
                                      .materials[index]
                                      .id))
                              ? GestureDetector(
                                  onTap: () {
                                    final sizeId = context
                                        .read<ProductBloc>()
                                        .state
                                        .materials[index]
                                        .id;
                                    context.read<ProductFilterBloc>().add(
                                        RemoveSelectedMaterialEvent(sizeId));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.smallSize,
                                        vertical: AppSize.xxSmallSize),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      borderRadius: BorderRadius.circular(
                                          AppSize.xxSmallSize),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    child: Text(
                                      Captilizations.capitalize(
                                        LocalizationMap.getMaterialMap(
                                            context,
                                            context
                                                .watch<ProductBloc>()
                                                .state
                                                .materials[index]
                                                .name),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    final brandId = context
                                        .read<ProductBloc>()
                                        .state
                                        .materials[index]
                                        .id;
                                    context
                                        .read<ProductFilterBloc>()
                                        .add(AddSelectedMaterialEvent(brandId));
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.smallSize,
                                          vertical: AppSize.xxSmallSize),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSize.xxSmallSize),
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHigh,
                                        ),
                                      ),
                                      child: Text(
                                        Captilizations.capitalize(
                                          LocalizationMap.getMaterialMap(
                                              context,
                                              context
                                                  .watch<ProductBloc>()
                                                  .state
                                                  .materials[index]
                                                  .name),
                                        ),
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
            ),
          ),
          if (context.watch<ProductBloc>().state.materialStatus ==
              MaterialStatus.loading)
            const LinearProgressIndicator(),
          Container(
            padding: const EdgeInsets.all(AppSize.smallSize),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: BottomFilterBar(
                isAdd: isAdd,
                onTapClear: () {
                  context
                      .read<ProductFilterBloc>()
                      .add(ClearSelectedMaterialsEvent());
                },
                onTapResult: () {
                  onTap();
                  Navigator.pop(context, true);
                }),
          )
        ],
      ),
    );
  }
}
