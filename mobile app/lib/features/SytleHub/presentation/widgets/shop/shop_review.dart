import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../pages/shop_review.dart';
import '../../pages/shop_review_write.dart';
import '../../pages/show_review_edit.dart';
import '../shimmer/chat_list_tile_shimmer.dart';
import 'review_widget.dart';

class ShopReview extends StatelessWidget {
  const ShopReview({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context) {
    if (context.read<ShopBloc>().state.shopProductReviewStatus ==
        ShopProductReviewStatus.loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [for (int i = 0; i < 4; i++) const ChatListTileShimmer()],
      );
    }

    if (context.watch<ShopBloc>().state.shopProductReviewStatus ==
            ShopProductReviewStatus.failure ||
        context.watch<ShopBloc>().state.shops[shopId]!.reviews.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: AppSize.largeSize),
          Image.asset('assets/images/Screens/review.png'),
          const SizedBox(height: AppSize.smallSize),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
            child: Text(
              AppLocalizations.of(context)!.shopReview_noReviews,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          const SizedBox(height: AppSize.largeSize),
          if (context.watch<UserBloc>().state.user?.id != shopId)
            GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: const RouteSettings(name: '/shop/review'),
                  withNavBar: false,
                  screen: ShopReviewWrite(shopId: shopId),
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.shopReview_writeReview,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var review in context
            .watch<ShopBloc>()
            .state
            .shops[shopId]!
            .reviews
            .values
            .toList()
            .sublist(
                0,
                min(
                    4,
                    context
                        .watch<ShopBloc>()
                        .state
                        .shops[shopId]!
                        .reviews
                        .length)))
          Container(
            margin: const EdgeInsets.only(bottom: AppSize.mediumSize),
            child: ReviewWidget(
              review: review,
              onEdit: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: const RouteSettings(name: '/shop/review/edit'),
                  withNavBar: false,
                  screen: ShowReviewEdit(
                    review: review,
                  ),
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              onDelete: () {
                context.read<ShopBloc>().add(DeleteReviewEvent(
                    review: review,
                    token: context.read<UserBloc>().state.user?.token ?? ''));
              },
              isShowEditAndDelete:
                  context.watch<UserBloc>().state.user?.id == review.userId,
            ),
          ),
        GestureDetector(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: const RouteSettings(name: '/shop/review'),
              withNavBar: false,
              screen: ShopReviewScreen(shopId: shopId),
              pageTransitionAnimation: PageTransitionAnimation.fade,
            );
          },
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.shopReview_seeAll,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSize.smallSize),
        if (context.watch<UserBloc>().state.user?.id != shopId)
          GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: const RouteSettings(name: '/shop/review'),
                withNavBar: false,
                screen: ShopReviewWrite(shopId: shopId),
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            },
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.shopReview_writeReview,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
