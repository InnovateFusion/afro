import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../../../setUp/shared_widgets/show_image.dart';
import '../../domain/entities/product_entity.dart';
import '../pages/product_detail.dart';


class Product extends StatelessWidget {
  final ProductEntity product;
  final bool showShop;

  const Product({
    super.key,
    required this.product,
    this.showShop = false,
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

    void gotoProductDetail(ProductEntity product) {
      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        context,
        settings: const RouteSettings(name: '/product/detail'),
        withNavBar: false,
        screen: ProductDetail(product: product, showShop: showShop),
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
    }

    return GestureDetector(
      onTap: () => gotoProductDetail(product),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: width,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 0.5,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: width,
                    height: width,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                    ),
                    child: product.images.isNotEmpty
                        ? ShowImage(image: product.images[0].imageUri)
                        : Icon(
                            Icons.image,
                            size: 50,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                  ),
                  if (product.createdAt.isAfter(
                      DateTime.now().subtract(const Duration(days: 7))))
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.xSmallSize - 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderRadius:
                              BorderRadius.circular(AppSize.xxSmallSize),
                        ),
                        child: Text(
                          'new',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Captilizations.capitalizeFirstOfEach(product.title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Text(
                  "ETB ${product.price}",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.shopInfo.subAdministrativeArea,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
