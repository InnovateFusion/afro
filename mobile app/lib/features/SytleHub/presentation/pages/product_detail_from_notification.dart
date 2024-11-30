import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/language/translation_map.dart';
import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/show_image.dart';
import 'shop_detail.dart';

class ProductDetailFromNotification extends StatefulWidget {
  const ProductDetailFromNotification({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailFromNotification> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailFromNotification> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();

    context.read<ShopBloc>().add(
          MakeContactEvent(
            productId: widget.productId,
            token: context.read<UserBloc>().state.user!.token ?? '',
          ),
        );

    context.read<ShopBloc>().add(
          GetShopProductByIdEvent(
            id: widget.productId,
            token: '',
          ),
        );
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget builderDetails(String title, Widget value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSize.xSmallSize),
          value,
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Stack(
          children: [
            if (context.watch<ShopBloc>().state.product != null &&
                context.watch<ShopBloc>().state.getShopProductByIdStatus ==
                    GetShopProductByIdStatus.success)
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSize.smallSize),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 32,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (context
                                      .watch<ShopBloc>()
                                      .state
                                      .product!
                                      .productApprovalStatus ==
                                  1 ||
                              context
                                      .watch<ShopBloc>()
                                      .state
                                      .product!
                                      .productApprovalStatus ==
                                  3)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.xxSmallSize,
                              ),
                              decoration: BoxDecoration(
                                color: context
                                            .watch<ShopBloc>()
                                            .state
                                            .product!
                                            .productApprovalStatus ==
                                        1
                                    ? Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer
                                    : Theme.of(context).colorScheme.error,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(AppSize.xxxLargeSize),
                                ),
                              ),
                              child: Text(
                                context
                                            .watch<ShopBloc>()
                                            .state
                                            .product!
                                            .productApprovalStatus ==
                                        1
                                    ? AppLocalizations.of(context)!.pending
                                    : AppLocalizations.of(context)!.rejected,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            )
                        ],
                      ),
                    ),
                    if (context
                        .watch<ShopBloc>()
                        .state
                        .product!
                        .images
                        .isNotEmpty)
                      GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity != null &&
                              details.primaryVelocity! > 0) {
                            if (selectedIndex > 0) {
                              changeIndex(selectedIndex - 1);
                            }
                          } else if (details.primaryVelocity != null &&
                              details.primaryVelocity! < 0) {
                            if (selectedIndex <
                                context
                                        .read<ShopBloc>()
                                        .state
                                        .product!
                                        .images
                                        .length -
                                    1) {
                              changeIndex(selectedIndex + 1);
                            }
                          }
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                            minHeight: 350,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 0.65,
                              ),
                            ),
                            child: Stack(
                              children: [
                                ShowImage(
                                    image: context
                                        .watch<ShopBloc>()
                                        .state
                                        .product!
                                        .images[selectedIndex]
                                        .imageUri),
                                if (context
                                    .watch<ShopBloc>()
                                    .state
                                    .product!
                                    .createdAt
                                    .isAfter(DateTime.now()
                                        .subtract(const Duration(days: 7))))
                                  Positioned(
                                    top: 10,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.xSmallSize - 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        borderRadius: BorderRadius.circular(
                                            AppSize.xxSmallSize),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .productDetailNewLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                if (context
                                        .watch<ShopBloc>()
                                        .state
                                        .product!
                                        .images
                                        .length >
                                    1)
                                  Positioned(
                                    bottom: 12,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int index = 0;
                                              index <
                                                  context
                                                      .watch<ShopBloc>()
                                                      .state
                                                      .product!
                                                      .images
                                                      .length;
                                              index++)
                                            GestureDetector(
                                              onTap: () {
                                                changeIndex(index);
                                              },
                                              child: Container(
                                                width: selectedIndex == index
                                                    ? 32
                                                    : 24,
                                                height: selectedIndex == index
                                                    ? 32
                                                    : 24,
                                                margin: const EdgeInsets.only(
                                                    right: AppSize.smallSize),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                  backgroundImage: NetworkImage(
                                                    context
                                                        .watch<ShopBloc>()
                                                        .state
                                                        .product!
                                                        .images[index]
                                                        .imageUri,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(AppSize.smallSize),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: AppSize.xSmallSize,
                                  runSpacing: AppSize.xSmallSize,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.smallSize - 4,
                                        vertical: AppSize.xxSmallSize - 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(AppSize.xxxLargeSize),
                                        ),
                                      ),
                                      child: Text(
                                        timeago.format(
                                          context
                                              .watch<ShopBloc>()
                                              .state
                                              .product!
                                              .createdAt,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.smallSize - 4,
                                        vertical: AppSize.xxSmallSize - 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(AppSize.xxxLargeSize),
                                        ),
                                      ),
                                      child: Text(
                                        context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .isNegotiable
                                            ? AppLocalizations.of(context)!
                                                .productDetailNegotiable
                                            : AppLocalizations.of(context)!
                                                .productDetailFixed,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ),
                                    if (context
                                        .watch<ShopBloc>()
                                        .state
                                        .product!
                                        .isDeliverable)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.smallSize - 4,
                                          vertical: AppSize.xxSmallSize - 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppSize.xxxLargeSize),
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .deliverable,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                        ),
                                      ),
                                    if (context
                                        .watch<ShopBloc>()
                                        .state
                                        .product!
                                        .inStock)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.smallSize - 4,
                                          vertical: AppSize.xxSmallSize - 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppSize.xxxLargeSize),
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!.inStock,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: AppSize.smallSize),
                                Text(
                                  Captilizations.capitalize(context
                                      .watch<ShopBloc>()
                                      .state
                                      .product!
                                      .title),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'ETB ${context.watch<ShopBloc>().state.product!.price}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                                Text(
                                  '${context.watch<ShopBloc>().state.product!.shopInfo.subLocality.isEmpty ? '' : '${context.watch<ShopBloc>().state.product!.shopInfo.subLocality} | '}${context.watch<ShopBloc>().state.product!.shopInfo.subAdministrativeArea}',
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
                            const SizedBox(height: AppSize.smallSize),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .description
                                .isNotEmpty)
                              if (context
                                  .watch<ShopBloc>()
                                  .state
                                  .product!
                                  .description
                                  .isNotEmpty)
                                builderDetails(
                                  AppLocalizations.of(context)!
                                      .productDetailDescription,
                                  Text(
                                    context
                                        .watch<ShopBloc>()
                                        .state
                                        .product!
                                        .description,
                                    textAlign: TextAlign.justify,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            height: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                  ),
                                ),
                            const SizedBox(height: AppSize.smallSize),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .colors
                                .isNotEmpty)
                              builderDetails(
                                AppLocalizations.of(context)!
                                    .productDetailColor,
                                Wrap(
                                  spacing: AppSize.mediumSize,
                                  runSpacing: AppSize.smallSize,
                                  children: [
                                    for (int index = 0;
                                        index <
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .colors
                                                .length;
                                        index++)
                                      Column(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Color(int.parse(
                                                "FF${context.watch<ShopBloc>().state.product!.colors[index].hexCode.substring(1)}",
                                                radix: 16,
                                              )),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          const SizedBox(
                                              height: AppSize.xxSmallSize),
                                          Text(
                                            Captilizations.capitalize(
                                                LocalizationMap.getColorMap(
                                                    context,
                                                    context
                                                        .watch<ShopBloc>()
                                                        .state
                                                        .product!
                                                        .colors[index]
                                                        .name)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .colors
                                .isNotEmpty)
                              const SizedBox(height: AppSize.smallSize),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .sizes
                                .isNotEmpty)
                              builderDetails(
                                AppLocalizations.of(context)!.productDetailSize,
                                Wrap(
                                  spacing: AppSize.mediumSize,
                                  runSpacing: AppSize.smallSize,
                                  children: [
                                    for (int index = 0;
                                        index <
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .sizes
                                                .length;
                                        index++)
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(100),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .sizes[index]
                                                .abbreviation
                                                .toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .sizes
                                .isNotEmpty)
                              const SizedBox(height: AppSize.smallSize),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .brands
                                .isNotEmpty)
                              builderDetails(
                                AppLocalizations.of(context)!
                                    .productDetailBrand,
                                Wrap(
                                  spacing: AppSize.mediumSize,
                                  runSpacing: AppSize.smallSize,
                                  children: [
                                    for (int index = 0;
                                        index <
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .brands
                                                .length;
                                        index++)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.xSmallSize,
                                          vertical: AppSize.xxSmallSize,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppSize.xxSmallSize),
                                          ),
                                        ),
                                        child: Text(
                                          Captilizations.capitalize(
                                              Captilizations.capitalize(
                                            LocalizationMap.getBrandMap(
                                                context,
                                                context
                                                    .watch<ShopBloc>()
                                                    .state
                                                    .product!
                                                    .brands[index]
                                                    .name
                                                    .toLowerCase()),
                                          )),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .brands
                                .isNotEmpty)
                              const SizedBox(height: AppSize.smallSize),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .designs
                                .isNotEmpty)
                              builderDetails(
                                AppLocalizations.of(context)!
                                    .productDetailDesign,
                                Wrap(
                                  spacing: AppSize.mediumSize,
                                  runSpacing: AppSize.smallSize,
                                  children: [
                                    for (int index = 0;
                                        index <
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .designs
                                                .length;
                                        index++)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.xSmallSize,
                                          vertical: AppSize.xxSmallSize,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppSize.xxSmallSize),
                                          ),
                                        ),
                                        child: Text(
                                          Captilizations.capitalize(
                                              LocalizationMap.getDesignMap(
                                                  context,
                                                  context
                                                      .watch<ShopBloc>()
                                                      .state
                                                      .product!
                                                      .designs[index]
                                                      .name)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .designs
                                .isNotEmpty)
                              const SizedBox(height: AppSize.smallSize),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .materials
                                .isNotEmpty)
                              builderDetails(
                                AppLocalizations.of(context)!
                                    .productDetailMaterial,
                                Wrap(
                                  spacing: AppSize.mediumSize,
                                  runSpacing: AppSize.smallSize,
                                  children: [
                                    for (int index = 0;
                                        index <
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .materials
                                                .length;
                                        index++)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSize.xSmallSize,
                                          vertical: AppSize.xxSmallSize,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppSize.xxSmallSize),
                                          ),
                                        ),
                                        child: Text(
                                          Captilizations.capitalize(
                                              LocalizationMap.getMaterialMap(
                                                  context,
                                                  context
                                                      .watch<ShopBloc>()
                                                      .state
                                                      .product!
                                                      .materials[index]
                                                      .name)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            if (context
                                .watch<ShopBloc>()
                                .state
                                .product!
                                .materials
                                .isNotEmpty)
                              const SizedBox(height: AppSize.smallSize),
                            Container(
                              padding: const EdgeInsets.all(
                                AppSize.xSmallSize,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.xSmallSize)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .shopInfo
                                                .logo,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .shopInfo
                                                .name
                                                .substring(
                                                    0,
                                                    min(
                                                        8,
                                                        context
                                                            .watch<ShopBloc>()
                                                            .state
                                                            .product!
                                                            .shopInfo
                                                            .name
                                                            .length)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                          ),
                                          Text(
                                            context
                                                .watch<ShopBloc>()
                                                .state
                                                .product!
                                                .shopInfo
                                                .subAdministrativeArea
                                                .substring(
                                                    0,
                                                    min(
                                                        14,
                                                        context
                                                            .watch<ShopBloc>()
                                                            .state
                                                            .product!
                                                            .shopInfo
                                                            .subAdministrativeArea
                                                            .length)),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  height: 1.2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      PersistentNavBarNavigator
                                          .pushNewScreenWithRouteSettings(
                                        context,
                                        settings: const RouteSettings(
                                            name: '/shop/detail'),
                                        withNavBar: false,
                                        screen: ShopDetail(
                                            shopId: context
                                                .read<ShopBloc>()
                                                .state
                                                .product!
                                                .shopInfo
                                                .id),
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 2,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                    icon: Icon(Icons.storefront,
                                        size: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                                    label: Text(
                                      AppLocalizations.of(context)!
                                          .productDetailViewShop,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              )
            else if (context.watch<ShopBloc>().state.getShopProductByIdStatus ==
                GetShopProductByIdStatus.loading)
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
              )
            else
              Center(
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
