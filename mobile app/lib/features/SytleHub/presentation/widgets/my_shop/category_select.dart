import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Localization Import

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/language/translation_map.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../bloc/product_filter/product_filter_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../common/category_chip.dart';
import '../common/category_swap_chip.dart';
import '../common/sub_category_list.dart';

class CategorySelection extends StatefulWidget {
  const CategorySelection({super.key});

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void addToSeletedCategory(String category) {
    if (context
        .read<ProductFilterBloc>()
        .state
        .selectedCategories
        .contains(category)) {
      context
          .read<ProductFilterBloc>()
          .add(RemoveSelectedCategoryEvent(category));
    } else {
      context.read<ProductFilterBloc>().add(AddSelectedCategoryEvent(category));
    }
  }

  void onChipTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSize.smallSize),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_outlined,
                            size: 32,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.categories,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(width: AppSize.xLargeSize),
                      ],
                    ),
                  ),
                  if (context.watch<ProductBloc>().state.domainStatus ==
                      DomainStatus.loading)
                    const Expanded(
                        child: Center(child: CircularProgressIndicator())),
                  if (context.watch<ProductBloc>().state.domainStatus ==
                      DomainStatus.success)
                    Container(
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
                        itemCount:
                            context.watch<ProductBloc>().state.domains.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: AppSize.mediumSize),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: CategorySwapChip(
                                text: Captilizations.capitalize(
                                    LocalizationMap.getDomainAndSubDomainMap(
                                        context,
                                        context
                                            .watch<ProductBloc>()
                                            .state
                                            .domains[index]
                                            .name)),
                                onTap: () => onChipTap(index),
                                isActive: index == currentIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (context.watch<ProductBloc>().state.domainStatus ==
                      DomainStatus.success)
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          int length =
                              context.read<ProductBloc>().state.domains.length;
                          if (details.primaryVelocity! > 0) {
                            if (currentIndex > 0) {
                              onChipTap(currentIndex - 1);
                            }
                          } else {
                            if (currentIndex < length - 1) {
                              onChipTap(currentIndex + 1);
                            }
                          }
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppSize.smallSize),
                          itemCount: context
                              .watch<ProductBloc>()
                              .state
                              .domains[currentIndex]
                              .subDomain
                              .length,
                          itemBuilder: (context, index) {
                            return SubCategoryList(
                              title: Captilizations.capitalizeFirstOfEach(
                                  LocalizationMap.getDomainAndSubDomainMap(
                                      context,
                                      context
                                          .watch<ProductBloc>()
                                          .state
                                          .domains[currentIndex]
                                          .subDomain[index]
                                          .name)),
                              subCategories: context
                                  .watch<ProductBloc>()
                                  .state
                                  .domains[currentIndex]
                                  .subDomain[index]
                                  .category
                                  .map((e) => CategoryChip(
                                      name:
                                          Captilizations.capitalizeFirstOfEach(
                                              LocalizationMap.getCategoryMap(
                                                  context, e.name)),
                                      image: e.image,
                                      isSelected: context
                                          .watch<ProductFilterBloc>()
                                          .state
                                          .selectedCategories
                                          .contains(e.id),
                                      onTap: () {
                                        addToSeletedCategory(e.id);
                                      }))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSize.smallSize),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context
                          .read<ProductFilterBloc>()
                          .add(ClearSelectedCategoriesEvent());
                    },
                    child: Text(
                      AppLocalizations.of(context)!.clear_all,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final selectedCategories = context
                          .read<ProductFilterBloc>()
                          .state
                          .selectedCategories
                          .length;
                      if (selectedCategories > 0) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .please_select_at_least_one_category,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.smallSize,
                          vertical: AppSize.xSmallSize),
                      margin: const EdgeInsets.only(right: AppSize.smallSize),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            BorderRadius.circular(AppSize.xxSmallSize),
                      ),
                      child: Text(
                        '${AppLocalizations.of(context)!.add} ${context.watch<ProductFilterBloc>().state.selectedCategories.isEmpty ? '' : '(${context.watch<ProductFilterBloc>().state.selectedCategories.length})'}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
