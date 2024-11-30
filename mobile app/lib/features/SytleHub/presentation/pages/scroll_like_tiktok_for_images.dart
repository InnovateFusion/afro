import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_hub/core/utils/captilizations.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_two.dart';
import '../widgets/common/product_image_viewer.dart';

class ScrollLikeTikTokForImages extends StatefulWidget {
  const ScrollLikeTikTokForImages({super.key, required this.openCloseDrawer});

  final VoidCallback openCloseDrawer;

  @override
  State<ScrollLikeTikTokForImages> createState() =>
      _ScrollLikeTikTokForImagesState();
}

class _ScrollLikeTikTokForImagesState extends State<ScrollLikeTikTokForImages> {
  late Controller controller;

  @override
  void initState() {
    controller = Controller()..addListener((event) {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.surfaceDim,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.smallSize),
              child: AppBarTwo(
                onTap: widget.openCloseDrawer,
                isColorWhite: true,
              ),
            ),
            Expanded(
              child: context.watch<ShopBloc>().state.products.values.isEmpty
                  ? Container()
                  : TikTokStyleFullPageScroller(
                      contentSize: context
                          .watch<ShopBloc>()
                          .state
                          .products
                          .values
                          .length,
                      swipePositionThreshold: 1,
                      swipeVelocityThreshold: 500,
                      animationDuration: const Duration(milliseconds: 300),
                      controller: controller,
                      builder: (BuildContext context, int index) {
                        final product = context
                            .watch<ShopBloc>()
                            .state
                            .products
                            .values
                            .toList()[index];

                        if (context
                                        .watch<ShopBloc>()
                                        .state
                                        .products
                                        .values
                                        .length -
                                    2 ==
                                index &&
                            (context
                                        .watch<ShopBloc>()
                                        .state
                                        .mainProductStatus !=
                                    MainProductsStatus.success ||
                                context
                                        .watch<ShopBloc>()
                                        .state
                                        .mainProductStatus !=
                                    MainProductsStatus.loadMore)) {
                          context.read<ShopBloc>().add(GetProductsEvent(
                                token: context
                                        .read<UserBloc>()
                                        .state
                                        .user
                                        ?.token ??
                                    '',
                                categoryIds: context
                                    .read<UserBloc>()
                                    .state
                                    .user
                                    ?.productCategoryPreferences,
                                homePageTabIndex: 0,
                                latitudes: context
                                    .read<UserBloc>()
                                    .state
                                    .user
                                    ?.latitude,
                                longitudes: context
                                    .read<UserBloc>()
                                    .state
                                    .user
                                    ?.longitude,
                                radiusInKilometers: 100,
                              ));
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: AppSize.largeSize),
                            ProductImageViewer(
                              product: product,
                            ),
                            Container(
                              padding: const EdgeInsets.all(AppSize.xSmallSize),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceDim
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Captilizations.capitalizeFirstOfEach(
                                        product.title),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                              .withOpacity(0.8),
                                        ),
                                  ),
                                  Text(
                                    Captilizations.capitalizeFirstOfEach(
                                        "ETB ${product.price}"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          height: 1.2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                              .withOpacity(0.5),
                                        ),
                                  ),
                                  Text(
                                    Captilizations.capitalizeFirstOfEach(
                                        product.shopInfo.subAdministrativeArea),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          height: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                              .withOpacity(0.5),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
