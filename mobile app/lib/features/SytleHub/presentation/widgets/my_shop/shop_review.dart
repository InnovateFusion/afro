import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../shimmer/chat_list_tile_shimmer.dart';
import '../shop/review_widget.dart';

class MyShopReview extends StatelessWidget {
  const MyShopReview({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context) {
    if (context.read<ShopBloc>().state.shopProductReviewStatus ==
        ShopProductReviewStatus.loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [for (int i = 0; i < 12; i++) const ChatListTileShimmer()],
      );
    }

    if (context.watch<ShopBloc>().state.shopProductReviewStatus ==
            ShopProductReviewStatus.failure ||
        context.watch<ShopBloc>().state.shops[shopId]!.reviews.isEmpty) {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Image.asset('assets/images/Screens/review.png'),
          const SizedBox(height: AppSize.smallSize),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
            child: Text(AppLocalizations.of(context)!.noReviewsYet,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary)),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var review
            in context.watch<ShopBloc>().state.shops[shopId]!.reviews.values)
          Container(
            margin: const EdgeInsets.only(bottom: AppSize.mediumSize),
            child: ReviewWidget(review: review, onDelete: () {}, onEdit: () {}),
          ),
      ],
    );
  }
}
