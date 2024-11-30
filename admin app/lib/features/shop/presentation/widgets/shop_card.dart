import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../../../setUp/shared_widgets/show_image.dart';
import '../../domain/entities/shop_entity.dart';
import '../pages/shop_detail.dart';

class ShopCard extends StatelessWidget {
  final ShopEntity shop;

  const ShopCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 340) {
    } else if (width <= 500) {
      width = (width - (16 * 3)) / 2;
    } else if (width <= 700) {
      width = (width - (16 * 4)) / 3;
    } else if (width <= 900) {
      width = (width - (16 * 5)) / 4;
    } else if (width <= 1100) {
      width = (width - (16 * 6)) / 5;
    } else if (width <= 1100) {
      width = (width - (16 * 7)) / 6;
    } else if (width <= 1400) {
      width = (width - (16 * 8)) / 7;
    } else {
      width = (width - (16 * 9)) / 8;
    }

    void gotoShopDetail(ShopEntity shop) {
      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        context,
        settings: const RouteSettings(name: '/shop/detail'),
        withNavBar: false,
        screen: ShopDetail(shop: shop),
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
    }

    return GestureDetector(
      onTap: () => gotoShopDetail(shop),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.smallSize),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Shop Image with a circular container
              Container(
                width: width,
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppSize.smallSize)),
                ),
                child: Stack(
                  children: [
                    // Background image (shop logo)
                    Container(
                      width: width,
                      height: width * 0.65,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSize.smallSize),
                      ),
                      child: ShowImage(image: shop.logo),
                    ),
                    // Gradient overlay for the image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSize.smallSize),
                          border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSize.xSmallSize),

              // Shop details
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Shop name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            Captilizations.capitalize(shop.name),
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(width: AppSize.xxSmallSize),
                        if (shop.verificationStatus == 2)
                          Icon(
                            Icons.verified,
                            color: Colors.blueAccent.withOpacity(0.8),
                            size: 20,
                          ),
                      ],
                    ),

                    const SizedBox(height: AppSize.xSmallSize),

                    // Shop location
                    Text(
                      shop.subAdministrativeArea,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: AppSize.xSmallSize),
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
