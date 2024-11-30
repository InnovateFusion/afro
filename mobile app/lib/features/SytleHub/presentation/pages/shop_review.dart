import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_one.dart';
import '../widgets/shop/review_widget.dart';
import 'shop_review_write.dart';
import 'show_review_edit.dart';

class ShopReviewScreen extends StatefulWidget {
  const ShopReviewScreen({super.key, required this.shopId});

  final String shopId;

  @override
  State<ShopReviewScreen> createState() => _ShopReviewScreenState();
}

class _ShopReviewScreenState extends State<ShopReviewScreen> {
  bool isShowWriteReviewButton = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (isShowWriteReviewButton) {
        setState(() {
          isShowWriteReviewButton = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!isShowWriteReviewButton) {
        setState(() {
          isShowWriteReviewButton = true;
        });
      }
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ShopBloc>().add(GetShopReviewsEvent(shopId: widget.shopId));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ShopBloc>().state.shops[widget.shopId]!.reviews.isEmpty) {
      return SafeArea(
        child: Scaffold(
          floatingActionButton: isShowWriteReviewButton
              ? FloatingActionButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(name: '/shop/review'),
                      withNavBar: false,
                      screen: ShopReviewWrite(shopId: widget.shopId),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 36,
                  ),
                )
              : null,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: Column(
            children: [
              const AppBarOne(),
              Divider(
                color: Theme.of(context).colorScheme.primaryContainer,
                thickness: 2,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSize.smallSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/Screens/review.png'),
                      const SizedBox(height: AppSize.smallSize),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize),
                        child: Text(
                            AppLocalizations.of(context)!
                                .shopReviewScreen_noReviews,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                      ),
                      const SizedBox(height: AppSize.xxxLargeSize),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        floatingActionButton: isShowWriteReviewButton &&
                context.watch<UserBloc>().state.user?.id != widget.shopId
            ? FloatingActionButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: '/shop/review'),
                    withNavBar: false,
                    screen: ShopReviewWrite(shopId: widget.shopId),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 36,
                ),
              )
            : null,
        body: Column(
          children: [
            const AppBarOne(),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              thickness: 2,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var review in context
                          .watch<ShopBloc>()
                          .state
                          .shops[widget.shopId]!
                          .reviews
                          .values)
                        Container(
                          margin:
                              const EdgeInsets.only(bottom: AppSize.mediumSize),
                          child: ReviewWidget(
                            review: review,
                            onEdit: () {
                              PersistentNavBarNavigator
                                  .pushNewScreenWithRouteSettings(
                                context,
                                settings: const RouteSettings(
                                    name: '/shop/review/edit'),
                                withNavBar: false,
                                screen: ShowReviewEdit(review: review),
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            },
                            onDelete: () {
                              context.read<ShopBloc>().add(DeleteReviewEvent(
                                  review: review,
                                  token: context
                                          .read<UserBloc>()
                                          .state
                                          .user
                                          ?.token ??
                                      ''));
                            },
                            isShowEditAndDelete:
                                context.watch<UserBloc>().state.user?.id ==
                                    review.userId,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (context.watch<ShopBloc>().state.shopProductReviewStatus ==
                ShopProductReviewStatus.loadMore)
              Padding(
                padding: const EdgeInsets.all(AppSize.smallSize),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
