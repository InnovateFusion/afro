import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../shimmer/my_shop_analytic_shimmer.dart';
import 'rating_overview.dart';
import 'shop_analytics.dart';

class MyShopAnalytic extends StatelessWidget {
  const MyShopAnalytic({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context) {
    return context.watch<ShopBloc>().state.shopAnalyticsStatus ==
            ShopAnalyticsStatus.loading
        ? const MyShopAnalyticShimmer()
        : Column(
            children: [
              AnalyticsCard(
                totalFollowers: context
                    .watch<ShopBloc>()
                    .state
                    .analyticShopEntity
                    .totalFollowers,
                totalReviews: context
                    .watch<ShopBloc>()
                    .state
                    .analyticShopEntity
                    .totalReviews,
                totalFavorites: context
                    .watch<ShopBloc>()
                    .state
                    .analyticShopEntity
                    .totalFavorites,
                totalProducts: context
                    .watch<ShopBloc>()
                    .state
                    .analyticShopEntity
                    .totalProducts,
                totalContacts: context
                    .watch<ShopBloc>()
                    .state
                    .analyticShopEntity
                    .totalContacts,
                totalViews: context
                    .watch<ShopBloc>()
                    .state
                    .analyticShopEntity
                    .totalViews,
              ),
              const SizedBox(height: AppSize.mediumSize),
              RatingOverviewWidget(
                averageRating:
                    context.watch<ShopBloc>().state.shops[shopId]?.rating ??
                        0.0,
                totalReviews: context
                    .watch<ShopBloc>()
                    .state
                    .analyticShopEntity
                    .totalReviews,
                ratingsCount: {
                  5: context
                      .watch<ShopBloc>()
                      .state
                      .analyticShopEntity
                      .fiveStarReviews,
                  4: context
                      .watch<ShopBloc>()
                      .state
                      .analyticShopEntity
                      .fourStarReviews,
                  3: context
                      .watch<ShopBloc>()
                      .state
                      .analyticShopEntity
                      .threeStarReviews,
                  2: context
                      .watch<ShopBloc>()
                      .state
                      .analyticShopEntity
                      .twoStarReviews,
                  1: context
                      .watch<ShopBloc>()
                      .state
                      .analyticShopEntity
                      .oneStarReviews,
                },
              ),
            ],
          );
  }
}
