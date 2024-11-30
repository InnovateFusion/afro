import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/language/translation_map.dart';
import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/product/category_entity.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/scroll/scroll_bloc.dart';
import '../widgets/common/app_bar_two.dart';
import '../widgets/common/category_chip.dart';
import '../widgets/common/category_swap_chip.dart';
import '../widgets/common/sub_category_list.dart';
import '../widgets/shimmer/category.dart';
import 'product_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.openCloseDrawer});

  final VoidCallback openCloseDrawer;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;
  int currentIndex = 0;

  void _scrollListener() {
    if (_scrollEndTimer != null && _scrollEndTimer!.isActive) {
      _scrollEndTimer!.cancel();
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      context.read<ScrollBloc>().add(ToggleVisibilityEvent(isVisible: false));
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      context.read<ScrollBloc>().add(ToggleVisibilityEvent(isVisible: true));
    }
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void gotoProductList(List<CategoryEntity> categories) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      settings: const RouteSettings(name: '/productList'),
      withNavBar: false,
      screen: ProductList(categories: categories),
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );
  }

  void onChipTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSize.smallSize),
            child: AppBarTwo(
              onTap: widget.openCloseDrawer,
            ),
          ),
          if (context.watch<ProductBloc>().state.domainStatus ==
              DomainStatus.loading)
            const CategoryShimmer(),
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
                itemCount: context.watch<ProductBloc>().state.domains.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSize.mediumSize),
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
                  int length = context.read<ProductBloc>().state.domains.length;
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
                  controller: _scrollController,
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
                                  .name
                                  .toLowerCase())),
                      subCategories: context
                          .watch<ProductBloc>()
                          .state
                          .domains[currentIndex]
                          .subDomain[index]
                          .category
                          .map((e) => CategoryChip(
                              name: LocalizationMap.getCategoryMap(
                                  context, e.name.toLowerCase()),
                              image: e.image,
                              isSelected: false,
                              onTap: () {
                                final List<CategoryEntity> categories = [
                                  e,
                                ];
                                for (int i = 0;
                                    i <
                                        context
                                            .read<ProductBloc>()
                                            .state
                                            .domains[currentIndex]
                                            .subDomain[index]
                                            .category
                                            .length;
                                    i++) {
                                  if (i != index) {
                                    if (context
                                            .read<ProductBloc>()
                                            .state
                                            .domains[currentIndex]
                                            .subDomain[index]
                                            .category[i]
                                            .id !=
                                        e.id) {
                                      categories.add(context
                                          .read<ProductBloc>()
                                          .state
                                          .domains[currentIndex]
                                          .subDomain[index]
                                          .category[i]);
                                    }
                                  }
                                }
                                gotoProductList(categories);
                              }))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
