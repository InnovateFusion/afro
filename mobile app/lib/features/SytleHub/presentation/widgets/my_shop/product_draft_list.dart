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

class MyShopProductDraftList extends StatefulWidget {
  final String shopId;
  const MyShopProductDraftList({super.key, required this.shopId});

  @override
  State<MyShopProductDraftList> createState() =>
      _MyShopProductArchieveListState();
}

class _MyShopProductArchieveListState extends State<MyShopProductDraftList> {
  @override
  Widget build(BuildContext context) {
    List<ProductEntity> products =
        context.watch<ShopBloc>().state.draftProducts.values.toList();

    if (context.read<ShopBloc>().state.listDraftProductsStatus ==
        ListDraftProductsStatus.loading) {
      return Wrap(
        spacing: AppSize.smallSize,
        runSpacing: AppSize.smallSize,
        children: List.generate(
          6,
          (index) => const ProductShimmer(),
        ),
      );
    }

    if (products.isEmpty) {
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
                AppLocalizations.of(context)!.noDraftProductFound,
                textAlign: TextAlign.center,
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
                          MyProductDetail(product: product, displayButton: 2),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  },
                  child: MyProduct(
                    product: product,
                  ),
                ))
            .toList());
  }
}
