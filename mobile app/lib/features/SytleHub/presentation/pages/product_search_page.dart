import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../../core/utils/captilizations.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/no_search_result.dart';
import '../widgets/shimmer/shop_list_tile_shimmer.dart';
import 'product_detail.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
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
      context.read<ProductBloc>().add(
            SearchProductEvent(
              token: context.read<UserBloc>().state.user!.token ?? '',
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
                          .read<ProductBloc>()
                          .add(SearchProductEvent(query: '', token: ''));
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
                          hintText: AppLocalizations.of(context)!
                              .productSearchPage_searchHint,
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
                            context.read<ProductBloc>().add(SearchProductEvent(
                                  token: context
                                          .read<UserBloc>()
                                          .state
                                          .user!
                                          .token ??
                                      '',
                                  query: '',
                                ));
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
                        context.read<ProductBloc>().add(
                              SearchProductEvent(
                                token: context
                                        .read<UserBloc>()
                                        .state
                                        .user!
                                        .token ??
                                    '',
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
              child: context.watch<ProductBloc>().state.searchStatus ==
                      ProductSearchStatus.loading
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
                  : (context.watch<ProductBloc>().state.searchResult.isEmpty &&
                          (context.watch<ProductBloc>().state.searchStatus ==
                                  ProductSearchStatus.success ||
                              context.watch<ProductBloc>().state.searchStatus ==
                                  ProductSearchStatus.failure ||
                              context.watch<ProductBloc>().state.searchStatus ==
                                  ProductSearchStatus.noMore))
                      ? const NoSearchResult()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.xSmallSize,
                          ),
                          itemCount: context
                              .watch<ProductBloc>()
                              .state
                              .searchResult
                              .length,
                          itemBuilder: (context, index) {
                            final product = context
                                .watch<ProductBloc>()
                                .state
                                .searchResult[index];

                            return GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator
                                    .pushNewScreenWithRouteSettings(
                                  context,
                                  settings: const RouteSettings(
                                    name: '/product_detail',
                                  ),
                                  screen: ProductDetail(
                                    product: product,
                                    showShop: true,
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.slideRight,
                                );
                              },
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
                                      product.images.first.imageUri,
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
                                          Captilizations.capitalize(
                                              product.title.substring(
                                                  0,
                                                  min(14,
                                                      product.title.length))),
                                          locale:
                                              Localizations.localeOf(context),
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w700,
                                              )),
                                      Text(
                                        'ETB ${product.price}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                      Text(
                                        product.shopInfo.subAdministrativeArea,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                      const SizedBox(height: AppSize.smallSize),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            if (context.watch<ProductBloc>().state.searchStatus ==
                ProductSearchStatus.loadMore)
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
