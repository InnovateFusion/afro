import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/chat/chat_participant_entity.dart';
import '../../domain/entities/shop/shop_entity.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_one.dart';
import '../widgets/shop/product_list.dart';
import '../widgets/shop/shop_about.dart';
import '../widgets/shop/shop_product_images.dart';
import '../widgets/shop/shop_review.dart';
import 'chat_detail.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({super.key, required this.shopId});

  final String shopId;

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  int selectedTab = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<ShopBloc>().add(GetShopByIdEvent(id: widget.shopId));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (selectedTab == 0) {
          final userToken = context.read<UserBloc>().state.user?.token ?? '';

          context.read<ShopBloc>().add(GetShopProductsEvent(
                token: userToken,
                shopId: widget.shopId,
              ));
        } else if (selectedTab == 2) {
          context
              .read<ShopBloc>()
              .add(GetShopProductsImagesEvent(shopId: widget.shopId));
        }
      }
    });

    _fetchShopData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchShopData() {
    final userToken = context.read<UserBloc>().state.user?.token ?? '';

    context
        .read<ShopBloc>()
        .add(GetShopWorkingHoursEvent(shopId: widget.shopId));
    context.read<ShopBloc>().add(GetShopProductsEvent(
          token: userToken,
          shopId: widget.shopId,
        ));

    context.read<ShopBloc>().add(GetShopReviewsEvent(shopId: widget.shopId));
    context
        .read<ShopBloc>()
        .add(GetShopProductsImagesEvent(shopId: widget.shopId));
  }

  Future<void> shareContent(BuildContext context, ShopEntity shopInfo) async {
    final uri = Uri(
        scheme: "google.navigation",
        queryParameters: {'q': '${shopInfo.latitude}, ${shopInfo.longitude}'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(
              'Could not open Google Maps',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use localized tab titles
    List<String> tabs = [
      AppLocalizations.of(context)!.shopDetail_products,
      AppLocalizations.of(context)!.shopDetail_about,
      AppLocalizations.of(context)!.shopDetail_photos,
      AppLocalizations.of(context)!.shopDetail_review,
    ];

    void onChangeTab(int index) {
      setState(() {
        selectedTab = index;
      });
    }

    Widget getSelectedTabContent() {
      switch (selectedTab) {
        case 0:
          return ShopProductList(shopId: widget.shopId);
        case 1:
          return ShopAbout(shopId: widget.shopId);
        case 2:
          return ShopProductImages(shopId: widget.shopId);
        case 3:
          return ShopReview(shopId: widget.shopId);
        default:
          return ShopProductList(shopId: widget.shopId);
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ShopBloc>().add(GetShopProductsEvent(
                  token: context.read<UserBloc>().state.user?.token ?? '',
                  shopId: widget.shopId,
                ));

            context
                .read<ShopBloc>()
                .add(GetShopReviewsEvent(shopId: widget.shopId));
            context
                .read<ShopBloc>()
                .add(GetShopProductsImagesEvent(shopId: widget.shopId));
          },
          child: !context
                  .watch<ShopBloc>()
                  .state
                  .shops
                  .containsKey(widget.shopId)
              ? Container(
                  color: Theme.of(context).colorScheme.scrim.withOpacity(0.95),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: SpinKitCircle(
                        size: 200,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(300),
                              color: index.isEven
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                            ),
                          );
                        },
                      )),
                    ],
                  ),
                )
              : BlocListener<ShopBloc, ShopState>(
                  listener: (context, state) {
                    if (state.shopProductImageStatus ==
                            ShopProductImageStatus.failure ||
                        state.archiveProductsStatus ==
                            ArchiveProductsStatus.failure ||
                        state.unArchiveProductsStatus ==
                            UnArchiveProductsStatus.failure ||
                        state.unDraftProductsStatus ==
                            UnDraftProductsStatus.failure ||
                        state.draftProductsStatus ==
                            DraftProductsStatus.failure ||
                        state.deleteProductStatus ==
                            DeleteProductStatus.failure ||
                        state.addProductStatus == AddProductStatus.failure ||
                        state.updateProductStatus ==
                            UpdateProductStatus.failure) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Center(
                      //       child: Text(
                      //         state.errorMessage,
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .bodyMedium!
                      //             .copyWith(
                      //                 color: Theme.of(context)
                      //                     .colorScheme
                      //                     .onPrimary),
                      //       ),
                      //     ),
                      //     backgroundColor:
                      //         Theme.of(context).colorScheme.secondary,
                      //   ),
                      // );
                      context
                          .read<ShopBloc>()
                          .add(const ChangeStatusToInitialEvent());
                    }
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      const SliverToBoxAdapter(
                        child: AppBarOne(),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 230,
                              child: Stack(
                                children: [
                                  if (context
                                          .read<ShopBloc>()
                                          .state
                                          .shops[widget.shopId]
                                          ?.banner !=
                                      null)
                                    Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      child: Image.network(
                                        context
                                            .read<ShopBloc>()
                                            .state
                                            .shops[widget.shopId]!
                                            .banner!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons.photo,
                                              size: 90,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          );
                                        },
                                        frameBuilder: (context, child, frame,
                                            wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded) {
                                            return child;
                                          }
                                          return AnimatedOpacity(
                                            opacity: frame == null ? 0 : 1,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.easeOut,
                                            child: child,
                                          );
                                        },
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  Positioned(
                                    left: AppSize.smallSize,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      radius: 55,
                                      backgroundImage: NetworkImage(
                                        context
                                            .read<ShopBloc>()
                                            .state
                                            .shops[widget.shopId]!
                                            .logo,
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppSize.smallSize),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: AppSize.xxSmallSize,
                                    children: [
                                      Text(
                                        Captilizations.capitalizeFirstOfEach(
                                            context
                                                .read<ShopBloc>()
                                                .state
                                                .shops[widget.shopId]!
                                                .name),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                      ),
                                      context
                                                  .read<ShopBloc>()
                                                  .state
                                                  .shops[widget.shopId]!
                                                  .verificationStatus ==
                                              2
                                          ? Icon(
                                              Icons.verified,
                                              color: Colors.blueAccent
                                                  .withOpacity(0.8),
                                              size: 24,
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RatingStars(
                                            axis: Axis.horizontal,
                                            value: context
                                                .read<ShopBloc>()
                                                .state
                                                .shops[widget.shopId]!
                                                .rating
                                                .toDouble(),
                                            starCount: 5,
                                            starSize: 20,
                                            valueLabelColor:
                                                const Color(0xff9b9b9b),
                                            valueLabelTextStyle:
                                                const TextStyle(
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
                                            starOffColor:
                                                const Color(0xffe7e8ea),
                                            starColor: Colors.yellow,
                                            angle: 12,
                                          ),
                                          Text(
                                            context
                                                .read<ShopBloc>()
                                                .state
                                                .shops[widget.shopId]!
                                                .subAdministrativeArea,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => shareContent(
                                                context,
                                                context
                                                    .read<ShopBloc>()
                                                    .state
                                                    .shops[widget.shopId]!),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primaryContainer,
                                                ),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.location_on,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width: AppSize.smallSize),
                                          GestureDetector(
                                            onTap: () {
                                              context.read<ShopBloc>().add(
                                                  FollowOrUnFollowShopEvent(
                                                      shopId: widget.shopId,
                                                      token: context
                                                              .read<UserBloc>()
                                                              .state
                                                              .user
                                                              ?.token ??
                                                          ''));

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Center(
                                                    child: Text(
                                                      !context
                                                              .read<ShopBloc>()
                                                              .state
                                                              .shops[widget
                                                                  .shopId]!
                                                              .isFollowing
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .shopDetail_following
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .shopDetail_unFollowed,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary,
                                                          ),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                ),
                                              );
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              padding: const EdgeInsets.all(
                                                  AppSize.xSmallSize + 4),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppSize.xxLargeSize),
                                              ),
                                              child: AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                transitionBuilder:
                                                    (Widget child,
                                                        Animation<double>
                                                            animation) {
                                                  return ScaleTransition(
                                                    scale: animation,
                                                    child: child,
                                                  );
                                                },
                                                child: Icon(
                                                  context
                                                          .read<ShopBloc>()
                                                          .state
                                                          .shops[widget.shopId]!
                                                          .isFollowing
                                                      ? Icons
                                                          .notifications_active_rounded
                                                      : Icons.notifications_off,
                                                  key: ValueKey<bool>(context
                                                      .read<ShopBloc>()
                                                      .state
                                                      .shops[widget.shopId]!
                                                      .isFollowing),
                                                  color: context
                                                          .read<ShopBloc>()
                                                          .state
                                                          .shops[widget.shopId]!
                                                          .isFollowing
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSize.mediumSize),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: context
                                                .read<ShopBloc>()
                                                .state
                                                .shops[widget.shopId]!
                                                .phoneNumber,
                                          );
                                          await launchUrl(launchUri);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.smallSize - 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xxSmallSize),
                                          ),
                                          child: Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.call,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                                const SizedBox(
                                                    width: AppSize.xxSmallSize),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .shopDetail_callNow,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSize.smallSize),
                                      GestureDetector(
                                        onTap: () {
                                          final userId = context
                                              .read<ShopBloc>()
                                              .state
                                              .shops[widget.shopId]!
                                              .userId;
                                          if (userId ==
                                              context
                                                  .read<UserBloc>()
                                                  .state
                                                  .user!
                                                  .id) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .shopDetail_messageError,
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                        ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                              ),
                                            );
                                            return;
                                          }
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: const RouteSettings(
                                                name: '/shop/message'),
                                            withNavBar: false,
                                            screen: ChatPage(
                                              receiver: ChatParticipantEntity(
                                                  id: userId,
                                                  firstName: '',
                                                  lastName: '',
                                                  email: '',
                                                  chatEntities: const []),
                                            ),
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade,
                                          );
                                        },
                                        child: Container(
                                          width: 150,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.smallSize - 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xxSmallSize),
                                          ),
                                          child: Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.message,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                                const SizedBox(
                                                    width: AppSize.xxSmallSize),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .shopDetail_message,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverAppBar(
                        pinned: true,
                        automaticallyImplyLeading: false,
                        forceMaterialTransparency: true,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        toolbarHeight: 100,
                        flexibleSpace: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: AppSize.xSmallSize + 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            Container(
                              height: 65,
                              color: Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.smallSize,
                                  vertical: AppSize.xSmallSize),
                              child: Center(
                                child: ListView.builder(
                                  itemCount: tabs.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => onChangeTab(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: selectedTab == index
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                          borderRadius: BorderRadius.circular(
                                              AppSize.xLargeSize),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.smallSize,
                                          vertical: AppSize.xSmallSize,
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        child: Center(
                                          child: Text(
                                            tabs[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: selectedTab == index
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: AppSize.xSmallSize + 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.smallSize),
                          child: getSelectedTabContent(),
                        ),
                      ),
                      if (context
                                  .watch<ShopBloc>()
                                  .state
                                  .shopProductImageStatus ==
                              ShopProductImageStatus.loadMore ||
                          context.watch<ShopBloc>().state.shopProductsStatus ==
                                  ShopProductsStatus.loadMore &&
                              (selectedTab == 0 || selectedTab == 2))
                        SliverToBoxAdapter(
                            child: Padding(
                          padding: const EdgeInsets.all(AppSize.smallSize),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
