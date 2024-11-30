import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../common/product.dart';
import '../shimmer/product.dart';

class ShopProductList extends StatefulWidget {
  final String shopId;
  const ShopProductList({super.key, required this.shopId});

  @override
  State<ShopProductList> createState() => _ShopProductListState();
}

class _ShopProductListState extends State<ShopProductList> {
  @override
  Widget build(BuildContext context) {
    List<ProductEntity> products = context
            .watch<ShopBloc>()
            .state
            .shops[widget.shopId]
            ?.products
            .values
            .toList() ??
        [];

    if (context.watch<ShopBloc>().state.shopProductsStatus ==
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
        crossAxisAlignment: WrapCrossAlignment.start,
        children: products
            .where((e) => e.productApprovalStatus == 2)
            .map((product) => Product(
                  product: product,
                ))
            .toList(),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.smallSize),
        child: Column(
          children: [
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
