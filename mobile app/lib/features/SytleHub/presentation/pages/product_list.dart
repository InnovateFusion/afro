import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/language/translation_map.dart';
import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/product/category_entity.dart';
import '../bloc/product_filter/product_filter_bloc.dart';
import '../bloc/scroll/scroll_bloc.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_one.dart';
import '../widgets/common/button.dart';
import '../widgets/common/no_search_result.dart';
import '../widgets/common/product.dart';
import '../widgets/filter/all_filter.dart';
import '../widgets/filter/half_brand_filter.dart';
import '../widgets/filter/half_color_filter.dart';
import '../widgets/filter/half_design_filter.dart';
import '../widgets/filter/half_location_filter.dart';
import '../widgets/filter/half_material_filter.dart';
import '../widgets/filter/half_price_filter.dart';
import '../widgets/filter/half_size_filter.dart';
import '../widgets/shimmer/product.dart';
import 'filter/brand.dart';
import 'filter/color.dart';
import 'filter/design.dart';
import 'filter/location.dart';
import 'filter/material.dart';
import 'filter/price.dart';
import 'filter/size.dart';

enum Filters { color, material, size, brand, price, location, design, all }

class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.categories});

  final List<CategoryEntity> categories;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductFilterBloc>().add(ClearAllEvent());
    context.read<ShopBloc>().add(ClearFilteredProductsEvent());
    context.read<ShopBloc>().add(GetFilteredProductsEvent(
          token: context.read<UserBloc>().state.user?.token ?? "",
          categoryIds: [widget.categories[0].id],
          materialIds: context
              .read<ProductFilterBloc>()
              .state
              .selectedMaterials
              .toList(),
          sortBy: context.read<ProductFilterBloc>().state.sort,
          sortOrder: context.read<ProductFilterBloc>().state.order,
          inStock: context.read<ProductFilterBloc>().state.inStock,
          isNew: context.read<ProductFilterBloc>().state.isNew,
          isNegotiable: context.read<ProductFilterBloc>().state.isNegotiable,
          isDeliverable: context.read<ProductFilterBloc>().state.isDeliverable,
          designIds:
              context.read<ProductFilterBloc>().state.selectedDesigns.toList(),
          sizeIds:
              context.read<ProductFilterBloc>().state.selectedSizes.toList(),
          brandIds:
              context.read<ProductFilterBloc>().state.selectedBrands.toList(),
          colorIds:
              context.read<ProductFilterBloc>().state.selectedColors.toList(),
          latitudes: context.read<ProductFilterBloc>().state.latitute,
          longitudes: context.read<ProductFilterBloc>().state.longitude,
          radiusInKilometers: context.read<ProductFilterBloc>().state.distance,
          minPrice: context.read<ProductFilterBloc>().state.priceMin,
          maxPrice: context.read<ProductFilterBloc>().state.priceMax,
        ));

    _scrollController.addListener(_scrollListener);
  }

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;
  final TextEditingController searchController = TextEditingController();

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

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  bool isExpanded = false;

  void onfilter() {
    context.read<ShopBloc>().add(GetFilteredProductsEvent(
          token: context.read<UserBloc>().state.user?.token ?? "",
          categoryIds: currentIndex == null
              ? null
              : [widget.categories[currentIndex!].id],
          materialIds: context
              .watch<ProductFilterBloc>()
              .state
              .selectedMaterials
              .toList(),
          sortBy: context.watch<ProductFilterBloc>().state.sort,
          sortOrder: context.watch<ProductFilterBloc>().state.order,
          inStock: context.read<ProductFilterBloc>().state.inStock,
          isNew: context.read<ProductFilterBloc>().state.isNew,
          isNegotiable: context.read<ProductFilterBloc>().state.isNegotiable,
          isDeliverable: context.read<ProductFilterBloc>().state.isDeliverable,
          designIds:
              context.watch<ProductFilterBloc>().state.selectedDesigns.toList(),
          sizeIds:
              context.watch<ProductFilterBloc>().state.selectedSizes.toList(),
          brandIds:
              context.watch<ProductFilterBloc>().state.selectedBrands.toList(),
          colorIds:
              context.watch<ProductFilterBloc>().state.selectedColors.toList(),
          latitudes: context.watch<ProductFilterBloc>().state.latitute,
          longitudes: context.watch<ProductFilterBloc>().state.longitude,
          radiusInKilometers: context.watch<ProductFilterBloc>().state.distance,
          minPrice: context.watch<ProductFilterBloc>().state.priceMin,
          maxPrice: context.watch<ProductFilterBloc>().state.priceMax,
        ));
  }

  void loadMore() {
    context.read<ShopBloc>().add(GetFilteredProductsEvent(
          token: context.read<UserBloc>().state.user?.token ?? "",
          categoryIds: currentIndex == null
              ? null
              : [widget.categories[currentIndex!].id],
          materialIds: context
              .read<ProductFilterBloc>()
              .state
              .selectedMaterials
              .toList(),
          sortBy: context.read<ProductFilterBloc>().state.sort,
          sortOrder: context.read<ProductFilterBloc>().state.order,
          inStock: context.read<ProductFilterBloc>().state.inStock,
          isNew: context.read<ProductFilterBloc>().state.isNew,
          isNegotiable: context.read<ProductFilterBloc>().state.isNegotiable,
          isDeliverable: context.read<ProductFilterBloc>().state.isDeliverable,
          designIds:
              context.read<ProductFilterBloc>().state.selectedDesigns.toList(),
          sizeIds:
              context.read<ProductFilterBloc>().state.selectedSizes.toList(),
          brandIds:
              context.read<ProductFilterBloc>().state.selectedBrands.toList(),
          colorIds:
              context.read<ProductFilterBloc>().state.selectedColors.toList(),
          latitudes: context.read<ProductFilterBloc>().state.latitute,
          longitudes: context.read<ProductFilterBloc>().state.longitude,
          radiusInKilometers: context.read<ProductFilterBloc>().state.distance,
          minPrice: context.read<ProductFilterBloc>().state.priceMin,
          maxPrice: context.read<ProductFilterBloc>().state.priceMax,
        ));
  }

  void onClear() {
    currentIndex = null;
    context.read<ProductFilterBloc>().add(ClearAllEvent());
    context.read<ShopBloc>().add(GetFilteredProductsEvent(
          token: context.read<UserBloc>().state.user?.token ?? "",
        ));
  }

  void onChangeCategory(int index) {
    context.read<ProductFilterBloc>().add(ClearAllEvent());
    setState(() {
      currentIndex = currentIndex == index ? null : index;
    });
    loadMore();
  }

  void displayBottomSheet(BuildContext context, Filters filterType) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.xxxSmallSize),
          topRight: Radius.circular(AppSize.xxxSmallSize),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) async {
            if (details.delta.dy < -5) {
              final data = await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      filterType == Filters.color
                          ? ColorFullFilterScreen(isAdd: false, onTap: loadMore)
                          : filterType == Filters.price
                              ? PriceFullFilterScreen(
                                  isAdd: false, onTap: loadMore)
                              : filterType == Filters.material
                                  ? MaterialFullFilterScreen(
                                      isAdd: false, onTap: loadMore)
                                  : filterType == Filters.size
                                      ? SizeFullFilterScreen(
                                          isAdd: false, onTap: loadMore)
                                      : filterType == Filters.design
                                          ? DesignFullFilterScreen(
                                              isAdd: false, onTap: loadMore)
                                          : filterType == Filters.location
                                              ? LocationFullFilterScreen(
                                                  isAdd: false, onTap: loadMore)
                                              : filterType == Filters.brand
                                                  ? BrandFullFilterScreen(
                                                      isAdd: false,
                                                      onTap: loadMore)
                                                  : SafeArea(
                                                      child: Scaffold(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          body: AllFilterDisplay(
                                                              isAdd: false,
                                                              onTap: loadMore)),
                                                    ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
              if (data != null && data == true) {
                Navigator.pop(context);
              }
            }
            if (details.delta.dy > 5) {
              Navigator.pop(context);
            }
          },
          child: filterType == Filters.color
              ? HalfColorFilterDisplay(isAdd: false, onTap: loadMore)
              : filterType == Filters.price
                  ? HalfPriceFilterDisplay(isAdd: false, onTap: loadMore)
                  : filterType == Filters.material
                      ? HalfMaterialFilterDisplay(isAdd: false, onTap: loadMore)
                      : filterType == Filters.size
                          ? HalfSizeFilterDisplay(isAdd: false, onTap: loadMore)
                          : filterType == Filters.brand
                              ? HalfBrandFilterDisplay(
                                  isAdd: false, onTap: loadMore)
                              : filterType == Filters.location
                                  ? HalfLocationFilterDisplay(
                                      isAdd: false, onTap: loadMore)
                                  : filterType == Filters.design
                                      ? HalfDesignFilterDisplay(
                                          isAdd: false, onTap: loadMore)
                                      : AllFilterDisplay(
                                          isAdd: false, onTap: loadMore),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
          children: [
            const AppBarOne(),
            Container(
                height: 2,
                color: Theme.of(context).colorScheme.primaryContainer),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.smallSize),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Wrap(
                        spacing: AppSize.mediumSize,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: AppSize.xSmallSize,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                displayBottomSheet(context, Filters.all),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.filter_alt_outlined,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  AppLocalizations.of(context)!.filter_all,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // vertial line
                          Container(
                            height: 20,
                            width: 1,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),

                          // GestureDetector(
                          //   onTap: () =>
                          //       displayBottomSheet(context, Filters.brand),
                          //   child: Wrap(
                          //     children: [
                          //       Text(
                          //         AppLocalizations.of(context)!.filter_brand,
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .titleMedium!
                          //             .copyWith(
                          //               color: Theme.of(context)
                          //                   .colorScheme
                          //                   .onSurface,
                          //             ),
                          //       ),
                          //       if (context
                          //           .watch<ProductFilterBloc>()
                          //           .state
                          //           .selectedBrands
                          //           .isNotEmpty)
                          //         const SizedBox(width: AppSize.xxSmallSize),
                          //       if (context
                          //           .watch<ProductFilterBloc>()
                          //           .state
                          //           .selectedBrands
                          //           .isNotEmpty)
                          //         Container(
                          //           decoration: BoxDecoration(
                          //             color: Theme.of(context)
                          //                 .colorScheme
                          //                 .primary
                          //                 .withOpacity(0.5),
                          //             shape: BoxShape.circle,
                          //           ),
                          //           padding: const EdgeInsets.all(
                          //               AppSize.xxSmallSize),
                          //           child: Text(
                          //             context
                          //                 .watch<ProductFilterBloc>()
                          //                 .state
                          //                 .selectedBrands
                          //                 .length
                          //                 .toString(),
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .bodySmall!
                          //                 .copyWith(
                          //                   fontSize: 10,
                          //                   color: Theme.of(context)
                          //                       .colorScheme
                          //                       .onPrimaryContainer,
                          //                 ),
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          // ),

                          GestureDetector(
                            onTap: () =>
                                displayBottomSheet(context, Filters.color),
                            child: Wrap(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.filter_color,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                if (context
                                    .watch<ProductFilterBloc>()
                                    .state
                                    .selectedColors
                                    .isNotEmpty)
                                  const SizedBox(width: AppSize.xxSmallSize),
                                if (context
                                    .watch<ProductFilterBloc>()
                                    .state
                                    .selectedColors
                                    .isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(
                                        AppSize.xxSmallSize),
                                    child: Text(
                                      context
                                          .watch<ProductFilterBloc>()
                                          .state
                                          .selectedColors
                                          .length
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () =>
                          //       displayBottomSheet(context, Filters.design),
                          //   child: Wrap(
                          //     children: [
                          //       Text(
                          //         AppLocalizations.of(context)!.filter_design,
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .titleMedium!
                          //             .copyWith(
                          //               color: Theme.of(context)
                          //                   .colorScheme
                          //                   .onSurface,
                          //             ),
                          //       ),
                          //       if (context
                          //           .watch<ProductFilterBloc>()
                          //           .state
                          //           .selectedDesigns
                          //           .isNotEmpty)
                          //         const SizedBox(width: AppSize.xxSmallSize),
                          //       if (context
                          //           .watch<ProductFilterBloc>()
                          //           .state
                          //           .selectedDesigns
                          //           .isNotEmpty)
                          //         Container(
                          //           decoration: BoxDecoration(
                          //             color: Theme.of(context)
                          //                 .colorScheme
                          //                 .primary
                          //                 .withOpacity(0.5),
                          //             shape: BoxShape.circle,
                          //           ),
                          //           padding: const EdgeInsets.all(
                          //               AppSize.xxSmallSize),
                          //           child: Text(
                          //             context
                          //                 .watch<ProductFilterBloc>()
                          //                 .state
                          //                 .selectedDesigns
                          //                 .length
                          //                 .toString(),
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .bodySmall!
                          //                 .copyWith(
                          //                   fontSize: 10,
                          //                   color: Theme.of(context)
                          //                       .colorScheme
                          //                       .onPrimaryContainer,
                          //                 ),
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () =>
                                displayBottomSheet(context, Filters.location),
                            child: Wrap(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.filter_location,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                if (context
                                        .watch<ProductFilterBloc>()
                                        .state
                                        .latitute !=
                                    0)
                                  const SizedBox(width: AppSize.xxSmallSize),
                                if (context
                                        .watch<ProductFilterBloc>()
                                        .state
                                        .latitute !=
                                    0)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(
                                        AppSize.xxSmallSize),
                                    child: Text(
                                      " ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () =>
                          //       displayBottomSheet(context, Filters.material),
                          //   child: Wrap(
                          //     children: [
                          //       Text(
                          //         AppLocalizations.of(context)!.filter_material,
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .titleMedium!
                          //             .copyWith(
                          //               color: Theme.of(context)
                          //                   .colorScheme
                          //                   .onSurface,
                          //             ),
                          //       ),
                          //       if (context
                          //           .watch<ProductFilterBloc>()
                          //           .state
                          //           .selectedMaterials
                          //           .isNotEmpty)
                          //         const SizedBox(width: AppSize.xxSmallSize),
                          //       if (context
                          //           .watch<ProductFilterBloc>()
                          //           .state
                          //           .selectedMaterials
                          //           .isNotEmpty)
                          //         Container(
                          //           decoration: BoxDecoration(
                          //             color: Theme.of(context)
                          //                 .colorScheme
                          //                 .primary
                          //                 .withOpacity(0.5),
                          //             shape: BoxShape.circle,
                          //           ),
                          //           padding: const EdgeInsets.all(
                          //               AppSize.xxSmallSize),
                          //           child: Text(
                          //             context
                          //                 .watch<ProductFilterBloc>()
                          //                 .state
                          //                 .selectedMaterials
                          //                 .length
                          //                 .toString(),
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .bodySmall!
                          //                 .copyWith(
                          //                   fontSize: 10,
                          //                   color: Theme.of(context)
                          //                       .colorScheme
                          //                       .onPrimaryContainer,
                          //                 ),
                          //           ),
                          //         ),
                          //     ],
                          //   ),
                          // ),

                          GestureDetector(
                            onTap: () =>
                                displayBottomSheet(context, Filters.price),
                            child: Wrap(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.filter_price,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                if (context
                                        .watch<ProductFilterBloc>()
                                        .state
                                        .priceMin !=
                                    -1)
                                  const SizedBox(width: AppSize.xxSmallSize),
                                if (context
                                        .watch<ProductFilterBloc>()
                                        .state
                                        .priceMin !=
                                    -1)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(
                                        AppSize.xxSmallSize),
                                    child: Text(
                                      ' ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 10,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () =>
                                displayBottomSheet(context, Filters.size),
                            child: Wrap(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.filter_size,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                if (context
                                    .watch<ProductFilterBloc>()
                                    .state
                                    .selectedSizes
                                    .isNotEmpty)
                                  const SizedBox(width: AppSize.xxSmallSize),
                                if (context
                                    .watch<ProductFilterBloc>()
                                    .state
                                    .selectedSizes
                                    .isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(
                                        AppSize.xxSmallSize),
                                    child: Text(
                                      context
                                          .watch<ProductFilterBloc>()
                                          .state
                                          .selectedSizes
                                          .length
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: onClear,
                            child: Text(
                              AppLocalizations.of(context)!.filter_reset,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: AppSize.smallSize)),
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      forceMaterialTransparency: true,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      toolbarHeight: 55,
                      flexibleSpace: Container(
                        color: Theme.of(context).colorScheme.onPrimary,
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.only(bottom: AppSize.smallSize),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.categories.length,
                          itemBuilder: (context, index) {
                            return ChipButton(
                              text: Captilizations.capitalizeFirstOfEach(
                                  LocalizationMap.getCategoryMap(
                                      context, widget.categories[index].name)),
                              onTap: () {
                                onChangeCategory(index);
                              },
                              isActive: index == currentIndex,
                            );
                          },
                        ),
                      ),
                    ),
                    if (context.watch<ShopBloc>().state.filteredProductStatus ==
                        FilteredProductStatus.loading)
                      SliverToBoxAdapter(
                          child: Wrap(
                        spacing: AppSize.smallSize,
                        runSpacing: AppSize.smallSize,
                        children: List.generate(
                          6,
                          (index) => const ProductShimmer(),
                        ),
                      )),
                    if (context
                            .watch<ShopBloc>()
                            .state
                            .filteredProducts
                            .isEmpty &&
                        (context
                                    .watch<ShopBloc>()
                                    .state
                                    .filteredProductStatus ==
                                FilteredProductStatus.success ||
                            context
                                    .watch<ShopBloc>()
                                    .state
                                    .filteredProductStatus ==
                                FilteredProductStatus.loaded))
                      const SliverToBoxAdapter(child: NoSearchResult()),
                    if (context.watch<ShopBloc>().state.filteredProductStatus ==
                            FilteredProductStatus.success ||
                        context.watch<ShopBloc>().state.filteredProductStatus ==
                            FilteredProductStatus.loaded ||
                        context.watch<ShopBloc>().state.filteredProductStatus ==
                            FilteredProductStatus.loadMore)
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: AppSize.smallSize,
                          runSpacing: AppSize.smallSize,
                          children: context
                              .watch<ShopBloc>()
                              .state
                              .filteredProducts
                              .where((e) => e.productApprovalStatus == 2)
                              .map((e) => Product(
                                    product: e,
                                  ))
                              .toList(),
                        ),
                      ),
                    if (context.watch<ShopBloc>().state.filteredProductStatus ==
                        FilteredProductStatus.loadMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.smallSize),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
