import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../pages/shop_verify_request.dart';

class AnalyticsCard extends StatelessWidget {
  final int totalFollowers;
  final int totalReviews;
  final int totalFavorites;
  final int totalProducts;
  final int totalContacts;
  final int totalViews;

  const AnalyticsCard({
    super.key,
    required this.totalFollowers,
    required this.totalReviews,
    required this.totalFavorites,
    required this.totalProducts,
    required this.totalContacts,
    required this.totalViews,
  });

  @override
  Widget build(BuildContext context) {
    Widget builderDetails(String title, Widget value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSize.xSmallSize),
          value,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context
                    .watch<ShopBloc>()
                    .state
                    .shops[context.read<ShopBloc>().state.myShopId ?? '']
                    ?.verificationStatus ==
                0 ||
            context
                    .watch<ShopBloc>()
                    .state
                    .shops[context.read<ShopBloc>().state.myShopId ?? '']
                    ?.verificationStatus ==
                3 ||
            context
                    .watch<ShopBloc>()
                    .state
                    .shops[context.read<ShopBloc>().state.myShopId ?? '']
                    ?.verificationStatus ==
                4)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.smallSize,
              vertical: AppSize.xSmallSize + 2,
            ),
            margin: const EdgeInsets.only(bottom: AppSize.smallSize),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSize.xSmallSize + 4),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: AppSize.xxSmallSize),
                    Text(
                      AppLocalizations.of(context)!.verifyYourShop,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings:
                          const RouteSettings(name: '/shop_verify_request'),
                      withNavBar: false,
                      screen: ShopVerificationRequest(
                        shopId: context.read<ShopBloc>().state.myShopId ?? '',
                      ),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.xSmallSize + 4,
                      vertical: AppSize.xxSmallSize,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.verify,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        builderDetails(
          AppLocalizations.of(context)!.analyticsCard_totalSummary,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnalyticsItem(
                    icon: Icons.people,
                    label:
                        AppLocalizations.of(context)!.analyticsCard_followers,
                    value: totalFollowers,
                  ),
                  const SizedBox(width: AppSize.smallSize),
                  AnalyticsItem(
                    icon: Icons.rate_review,
                    label: AppLocalizations.of(context)!.analyticsCard_reviews,
                    value: totalReviews,
                  ),
                ],
              ),
              const SizedBox(height: AppSize.smallSize),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnalyticsItem(
                    icon: Icons.favorite,
                    label:
                        AppLocalizations.of(context)!.analyticsCard_favorites,
                    value: totalFavorites,
                  ),
                  const SizedBox(width: AppSize.smallSize),
                  AnalyticsItem(
                    icon: Icons.shopping_bag,
                    label: AppLocalizations.of(context)!.analyticsCard_products,
                    value: totalProducts,
                  ),
                ],
              ),
              const SizedBox(height: AppSize.smallSize),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnalyticsItem(
                    icon: Icons.contact_mail,
                    label:
                        AppLocalizations.of(context)!.analyticsCard_impressions,
                    value: totalContacts,
                  ),
                  const SizedBox(width: AppSize.smallSize),
                  AnalyticsItem(
                    icon: Icons.visibility,
                    label: AppLocalizations.of(context)!.analyticsCard_views,
                    value: totalViews,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class AnalyticsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const AnalyticsItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  String formatNumber(num number) {
    if (number >= 1000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(1)}T'; // Trillion
    } else if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B'; // Billion
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M'; // Million
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K'; // Thousand
    } else {
      return number.toString(); // Less than 1000
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSize.xSmallSize),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  formatNumber(value),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(AppSize.xSmallSize),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
