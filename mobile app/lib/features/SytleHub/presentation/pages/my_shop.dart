import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/product_filter/product_filter_bloc.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_three.dart';
import '../widgets/common/no_internet_connection.dart';
import '../widgets/my_shop/my_shop_analytic.dart';
import '../widgets/my_shop/product_archieve_list.dart';
import '../widgets/my_shop/product_draft_list.dart';
import '../widgets/my_shop/product_list.dart';
import '../widgets/my_shop/shop_review.dart';
import '../widgets/shop/shop_product_images.dart';
import 'add_product.dart';

class MyShopScreen extends StatefulWidget {
  const MyShopScreen({super.key});

  @override
  State<MyShopScreen> createState() => _MyShopScreenState();
}

class _MyShopScreenState extends State<MyShopScreen> {
  int currentIndex = 0;
  bool isShowWriteReviewButton = true;
  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    context.read<ShopBloc>().add(const ResetShopImageUploadEvent());
    context.read<ShopBloc>().add(GetShopProductsEvent(
        token: context.read<UserBloc>().state.user?.token ?? '',
        shopId: context.read<ShopBloc>().state.myShopId ?? ""));
    context.read<ShopBloc>().add(GetShopWorkingHoursEvent(
        shopId: context.read<ShopBloc>().state.myShopId ?? ""));
    context.read<ShopBloc>().add(GetShopReviewsEvent(
        shopId: context.read<ShopBloc>().state.myShopId ?? ""));
    context.read<ShopBloc>().add(GetShopProductsImagesEvent(
        shopId: context.read<ShopBloc>().state.myShopId ?? ""));
    context.read<ShopBloc>().add(GetShopAnalyticEvent(
        token: context.read<UserBloc>().state.user?.token ?? '',
        id: context.read<ShopBloc>().state.myShopId ?? ""));
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
      if (currentIndex == 1) {
        final userToken = context.read<UserBloc>().state.user?.token ?? '';

        context.read<ShopBloc>().add(GetShopProductsEvent(
            token: userToken,
            shopId: context.read<ShopBloc>().state.myShopId ?? ""));
      } else if (currentIndex == 2) {
        context.read<ShopBloc>().add(GetShopProductsImagesEvent(
            shopId: context.read<ShopBloc>().state.myShopId ?? ""));
      } else if (currentIndex == 3) {
        context.read<ShopBloc>().add(GetShopReviewsEvent(
            shopId: context.read<ShopBloc>().state.myShopId ?? ""));
      } else if (currentIndex == 4) {
        context.read<ShopBloc>().add(GetArchivedProductsEvent(
              token: context.read<UserBloc>().state.user?.token ?? '',
            ));
      } else if (currentIndex == 5) {
        context.read<ShopBloc>().add(GetDraftProductsEvent(
              token: context.read<UserBloc>().state.user?.token ?? '',
            ));
      }
    }
  }

  void onChipTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      AppLocalizations.of(context)!.myShopScreen_analytics,
      AppLocalizations.of(context)!.myShopScreen_products,
      AppLocalizations.of(context)!.myShopScreen_photos,
      AppLocalizations.of(context)!.myShopScreen_reviews,
      AppLocalizations.of(context)!.myShopScreen_archives,
      AppLocalizations.of(context)!.myShopScreen_drafts,
    ];

    Widget onChangeWidget(int index) {
      switch (index) {
        case 0:
          return MyShopAnalytic(
              shopId: context.read<ShopBloc>().state.myShopId ?? "");
        case 1:
          return MyShopProductList(
              shopId: context.read<ShopBloc>().state.myShopId ?? "");
        case 2:
          return ShopProductImages(
              shopId: context.read<ShopBloc>().state.myShopId ?? "",
              myShop: true);
        case 3:
          return MyShopReview(
              shopId: context.read<ShopBloc>().state.myShopId ?? "");
        case 4:
          return MyShopProductArchieveList(
              shopId: context.read<ShopBloc>().state.myShopId ?? "");
        case 5:
          return MyShopProductDraftList(
              shopId: context.read<ShopBloc>().state.myShopId ?? "");
        default:
          return Container();
      }
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ShopBloc>().add(GetShopAnalyticEvent(
              token: context.read<UserBloc>().state.user?.token ?? '',
              id: context.read<ShopBloc>().state.myShopId ?? ""));
          context.read<ShopBloc>().add(GetShopProductsEvent(
              token: context.read<UserBloc>().state.user?.token ?? '',
              shopId: context.read<ShopBloc>().state.myShopId ?? ""));
          context.read<ShopBloc>().add(GetShopReviewsEvent(
              shopId: context.read<ShopBloc>().state.myShopId ?? ""));
          context.read<ShopBloc>().add(GetShopProductsImagesEvent(
              shopId: context.read<ShopBloc>().state.myShopId ?? ""));
        },
        child: BlocListener<ShopBloc, ShopState>(
          listener: (context, state) {
            if (state.shopImageUploadStatus == ShopImageUploadStatus.loading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Center(
                    child: Text(
                      AppLocalizations.of(context)!.myShopScreen_uploadingImage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
              context.read<ShopBloc>().add(const ChangeStatusToInitialEvent());
            } else if (state.shopImageUploadStatus ==
                ShopImageUploadStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      AppLocalizations.of(context)!.myShopScreen_imageUploaded,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
              context.read<ShopBloc>().add(const ChangeStatusToInitialEvent());
            }
          },
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                floatingActionButton: isShowWriteReviewButton &&
                        context.watch<ChatBloc>().signalRService.isConnected
                    ? FloatingActionButton(
                        onPressed: () {
                          context
                              .read<ProductFilterBloc>()
                              .add(ClearAllEvent());
                          PersistentNavBarNavigator
                              .pushNewScreenWithRouteSettings(
                            context,
                            settings: const RouteSettings(name: '/product/add'),
                            withNavBar: false,
                            screen: AddProductScreen(
                                shopId:
                                    context.read<ShopBloc>().state.myShopId ??
                                        ""),
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.add,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 36,
                        ),
                      )
                    : null,
                body: SizedBox(
                  width: double.infinity,
                  child: context.watch<ChatBloc>().signalRService.isConnected ==
                          false
                      ? const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NoInternetConnection(),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppBarThree(),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.only(
                                  left: AppSize.smallSize,
                                  right: AppSize.smallSize),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: tabs.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => onChipTap(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: currentIndex == index
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
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Center(
                                        child: Text(
                                          tabs[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: currentIndex == index
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 2,
                              margin: const EdgeInsets.only(
                                  top: AppSize.xSmallSize),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(AppSize.smallSize),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    controller: _scrollController,
                                    child: onChangeWidget(currentIndex)),
                              ),
                            ),
                            if ((context
                                            .watch<ShopBloc>()
                                            .state
                                            .shopProductImageStatus ==
                                        ShopProductImageStatus.loadMore ||
                                    context
                                            .watch<ShopBloc>()
                                            .state
                                            .shopProductsStatus ==
                                        ShopProductsStatus.loadMore ||
                                    context
                                            .watch<ShopBloc>()
                                            .state
                                            .shopProductReviewStatus ==
                                        ShopProductReviewStatus.loadMore ||
                                    context
                                            .watch<ShopBloc>()
                                            .state
                                            .listDraftProductsStatus ==
                                        ListDraftProductsStatus.loadMore ||
                                    context
                                            .watch<ShopBloc>()
                                            .state
                                            .listArchiveProductsStatus ==
                                        ListArchiveProductsStatus.loadMore) &&
                                (currentIndex == 1 ||
                                    currentIndex == 2 ||
                                    currentIndex == 3 ||
                                    currentIndex == 4 ||
                                    currentIndex == 5))
                              Padding(
                                padding:
                                    const EdgeInsets.all(AppSize.smallSize),
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
              ),
              if (context.watch<ShopBloc>().state.shopImageUploadStatus ==
                      ShopImageUploadStatus.loading ||
                  context.watch<ShopBloc>().state.deleteProductStatus ==
                      DeleteProductStatus.loading ||
                  context.watch<ShopBloc>().state.draftProductsStatus ==
                      DraftProductsStatus.loading ||
                  context.watch<ShopBloc>().state.unDraftProductsStatus ==
                      UnDraftProductsStatus.loading ||
                  context.watch<ShopBloc>().state.archiveProductsStatus ==
                      ArchiveProductsStatus.loading ||
                  context.watch<ShopBloc>().state.unArchiveProductsStatus ==
                      UnArchiveProductsStatus.loading)
                Container(
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
