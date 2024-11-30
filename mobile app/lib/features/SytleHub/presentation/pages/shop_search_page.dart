import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/no_search_result.dart';
import '../widgets/shimmer/shop_list_tile_shimmer.dart';
import 'shop_detail.dart';

class ShopSearchPage extends StatefulWidget {
  const ShopSearchPage({super.key});

  @override
  State<ShopSearchPage> createState() => _ShopSearchPageState();
}

class _ShopSearchPageState extends State<ShopSearchPage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ShopBloc>().add(
            SearchShopEvent(
              query: searchController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.smallSize),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context
                          .read<ShopBloc>()
                          .add(const SearchShopEvent(query: ''));
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: AppSize.smallSize),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.search_for_shop,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            context
                                .read<ShopBloc>()
                                .add(SearchShopEvent(query: value));
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.smallSize),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        context.read<ShopBloc>().add(
                              SearchShopEvent(
                                query: searchController.text,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              height: 1,
            ),
            const SizedBox(height: AppSize.smallSize),
            Expanded(
              child: context.watch<ShopBloc>().state.shopSearchStatus ==
                      ShopSearchStatus.loading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize,
                        vertical: AppSize.xSmallSize,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return const ShopListTileShimmer();
                      },
                    )
                  : (context.watch<ShopBloc>().state.searchResult.isEmpty &&
                          (context.watch<ShopBloc>().state.shopSearchStatus ==
                                  ShopSearchStatus.success ||
                              context
                                      .watch<ShopBloc>()
                                      .state
                                      .shopSearchStatus ==
                                  ShopSearchStatus.failure ||
                              context
                                      .watch<ShopBloc>()
                                      .state
                                      .shopSearchStatus ==
                                  ShopSearchStatus.noMore))
                      ? const NoSearchResult()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.xSmallSize,
                          ),
                          itemCount: context
                              .watch<ShopBloc>()
                              .state
                              .searchResult
                              .length,
                          itemBuilder: (context, index) {
                            final shop = context
                                .watch<ShopBloc>()
                                .state
                                .searchResult[index];

                            return GestureDetector(
                              onTap: () {
                                context.read<ShopBloc>().add(
                                      SetShopEvent(shop: shop),
                                    );
                                context.read<ShopBloc>().add(
                                      GetShopProductsEvent(
                                        token: context
                                                .read<UserBloc>()
                                                .state
                                                .user!
                                                .token ??
                                            '',
                                        shopId: shop.id,
                                      ),
                                    );
                                PersistentNavBarNavigator
                                    .pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(
                                    name: '/shop/${shop.id}',
                                  ),
                                  screen: ShopDetail(
                                    shopId: shop.id,
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.slideRight,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: AppSize.smallSize,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: BorderRadius.circular(
                                            AppSize.xSmallSize),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.network(
                                        shop.logo,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: AppSize.smallSize),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            shop.name.substring(
                                                0, min(18, shop.name.length)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                        RatingStars(
                                          axis: Axis.horizontal,
                                          value: shop.rating.toDouble(),
                                          starCount: 5,
                                          starSize: 20,
                                          valueLabelColor:
                                              const Color(0xff9b9b9b),
                                          valueLabelTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                          valueLabelRadius: 10,
                                          maxValue: 5,
                                          starSpacing: 2,
                                          maxValueVisibility: true,
                                          valueLabelVisibility: false,
                                          animationDuration: const Duration(
                                              milliseconds: 1000),
                                          valueLabelPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 1, horizontal: 8),
                                          valueLabelMargin:
                                              const EdgeInsets.only(right: 8),
                                          starOffColor: const Color(0xffe7e8ea),
                                          starColor: Colors.yellow,
                                          angle: 12,
                                        ),
                                        const SizedBox(
                                            height: AppSize.xSmallSize),
                                        Text(
                                          shop.subAdministrativeArea,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            if (context.watch<ShopBloc>().state.shopSearchStatus ==
                ShopSearchStatus.loadMore)
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
