import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../common/my_product.dart';
import '../shimmer/product.dart';
import 'my_product_detail.dart';

class MyShopProductList extends StatelessWidget {
  final String shopId;
  const MyShopProductList({super.key, required this.shopId});
  @override
  Widget build(BuildContext context) {
    List<ProductEntity> products = context
            .watch<ShopBloc>()
            .state
            .shops[shopId]
            ?.products
            .values
            .toList() ??
        [];

    if (context.read<ShopBloc>().state.shopProductsStatus ==
        ShopProductsStatus.loading) {
      return Wrap(
        spacing: AppSize.smallSize,
        runSpacing: AppSize.smallSize,
        children: List.generate(
          6,
          (index) => const ProductShimmer(),
        ),
      );
    }

    if (products.isNotEmpty) {
      return Wrap(
          spacing: AppSize.smallSize,
          runSpacing: AppSize.smallSize,
          children: products
              .map((product) => GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: const RouteSettings(name: '/product/detail'),
                        withNavBar: false,
                        screen:
                            MyProductDetail(product: product, displayButton: 0),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                    child: MyProduct(
                      product: product,
                    ),
                  ))
              .toList());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.smallSize),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Image.asset(
              'assets/images/Screens/no_data.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: AppSize.xSmallSize),
            Text(
              AppLocalizations.of(context)!.noProductsFound,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
