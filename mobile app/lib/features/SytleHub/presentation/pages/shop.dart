import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/product_filter/product_filter_bloc.dart';
import '../bloc/scroll/scroll_bloc.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_two.dart';
import '../widgets/common/no_search_result.dart';
import '../widgets/common/shop_card.dart';
import '../widgets/filter/shop_filter.dart';
import '../widgets/shimmer/shop.dart';
import 'shop_search_page.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.openCloseDrawer});

  final VoidCallback openCloseDrawer;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductFilterBloc>().add(ClearAllEvent());

    _scrollController.addListener(_scrollListener);
  }

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;
  final Set<String> selectedCategories = {};
  String? selectedVefification;
  double? selectedRating;

  void onSelectedCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void onSelectedVerification(String verification) {
    if (selectedVefification == verification) {
      selectedVefification = '';
    } else {
      selectedVefification = verification;
    }
  }

  void onSelectedRating(double rating) {
    if (selectedRating == rating) {
      selectedRating = 0.0;
    } else {
      selectedRating = rating;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      onFilter();
    }

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

  void displayBottomSheet(BuildContext context) {
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
        return SafeArea(
          child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              body: ShopFilter(
                onSelectedCategory: onSelectedCategory,
                selectedCategories: selectedCategories,
                onSelectedRating: onSelectedRating,
                selectedRating: selectedRating,
                onSelectedVerified: onSelectedVerification,
                selectedVerified: selectedVefification,
                onClear: onClear,
                onFilter: onFilter,
              )),
        );
      },
    );
  }

  void onClear() {
    context.read<ProductFilterBloc>().add(ClearAllEvent());

    setState(() {
      selectedCategories.clear();
      selectedRating = null;
      selectedVefification = null;
    });
    context.read<ShopBloc>().add(GetAllShopEvent(
          token: context.read<UserBloc>().state.user?.token ?? '',
          category: null,
          rating: null,
          verified: 2,
          latitudes: null,
          longitudes: null,
          radiusInKilometers: null,
        ));
  }

  void onFilter() {
    context.read<ShopBloc>().add(GetAllShopEvent(
          token: context.read<UserBloc>().state.user?.token ?? '',
          category: selectedCategories.toList(),
          rating: selectedRating?.toInt(),
          verified: selectedVefification == 'not verified'
              ? 0
              : selectedVefification == 'verified'
                  ? 2
                  : null,
          latitudes: context.read<ProductFilterBloc>().state.latitute == 0
              ? null
              : context.read<ProductFilterBloc>().state.latitute,
          longitudes: context.read<ProductFilterBloc>().state.longitude == 0
              ? null
              : context.read<ProductFilterBloc>().state.longitude,
          radiusInKilometers:
              context.read<ProductFilterBloc>().state.latitute == 0 ? null : 50,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ShopBloc>().add(GetAllShopEvent(
            verified: 2,
            token: context.read<UserBloc>().state.user?.token ?? ''));
      },
      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.all(AppSize.smallSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarTwo(
              onTap: widget.openCloseDrawer,
            ),
            const SizedBox(height: AppSize.mediumSize),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings:
                            const RouteSettings(name: '/shop_search_page'),
                        withNavBar: false,
                        screen: const ShopSearchPage(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize,
                        vertical: AppSize.xSmallSize + 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: AppSize.smallSize),
                          Text(
                            (selectedCategories.isNotEmpty ||
                                    selectedRating != null ||
                                    selectedVefification != null ||
                                    context
                                            .read<ProductFilterBloc>()
                                            .state
                                            .latitute !=
                                        0)
                                ? AppLocalizations.of(context)!
                                    .shopScreenFiltering
                                : AppLocalizations.of(context)!
                                    .shopScreenSearchHint,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.smallSize),
                GestureDetector(
                  onTap: () => displayBottomSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.xSmallSize + 4,
                      vertical: AppSize.xSmallSize + 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                if (selectedCategories.isNotEmpty ||
                    selectedRating != null ||
                    selectedVefification != null ||
                    context.read<ProductFilterBloc>().state.latitute != 0)
                  GestureDetector(
                    onTap: onClear,
                    child: Container(
                      margin: const EdgeInsets.only(left: AppSize.smallSize),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.xSmallSize + 4,
                        vertical: AppSize.xSmallSize + 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                      ),
                      child: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSize.mediumSize),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: (context.watch<ShopBloc>().state.shopsListStatus ==
                            ShopsListStatus.loading)
                        ? Wrap(
                            spacing: AppSize.smallSize,
                            runSpacing: AppSize.smallSize,
                            children: List.generate(
                              6,
                              (index) => const ShopShimmer(),
                            ),
                          )
                        : context.watch<ShopBloc>().state.shops.isEmpty
                            ? const NoSearchResult()
                            : Wrap(
                                spacing: AppSize.smallSize,
                                runSpacing: AppSize.smallSize,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  for (var shop in context
                                      .watch<ShopBloc>()
                                      .state
                                      .shops
                                      .entries)
                                    ShopCard(shop: shop.value),
                                ],
                              ),
                  )
                ],
              ),
            ),
            if (context.watch<ShopBloc>().state.shopsListStatus ==
                ShopsListStatus.loadMore)
              const Padding(
                padding: EdgeInsets.all(AppSize.smallSize),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
