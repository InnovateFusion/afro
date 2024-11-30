import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/language/translation_map.dart';
import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/chat/chat_participant_entity.dart';
import '../../domain/entities/product/product_entity.dart';
import '../../domain/entities/product/shop_info_entity.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/show_image.dart';
import 'chat_detail.dart';
import 'shop_detail.dart';
import 'upload_to_tiktok.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {super.key, required this.product, this.showShop = false});
  final ProductEntity product;
  final bool showShop;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.product.isFavorite;
    if (widget.product.shopInfo.id != context.read<UserBloc>().state.user!.id) {
      context.read<ShopBloc>().add(
            MakeContactEvent(
              productId: widget.product.id,
              token: context.read<UserBloc>().state.user!.token ?? '',
            ),
          );
    }
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

    Future<void> makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }

    Future<void> shareContent(
        BuildContext context, ShopInfoEntity shopInfo) async {
      final uri = Uri(scheme: "google.navigation", queryParameters: {
        'q': '${shopInfo.latitude}, ${shopInfo.longitude}'
      });
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

    void changeIndex(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: SingleChildScrollView(
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
                    if (widget.product.productApprovalStatus == 1 ||
                        widget.product.productApprovalStatus == 3)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.smallSize,
                          vertical: AppSize.xxSmallSize,
                        ),
                        decoration: BoxDecoration(
                          color: widget.product.productApprovalStatus == 1
                              ? Theme.of(context).colorScheme.tertiaryContainer
                              : Theme.of(context).colorScheme.error,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(AppSize.xxxLargeSize),
                          ),
                        ),
                        child: Text(
                          widget.product.productApprovalStatus == 1
                              ? AppLocalizations.of(context)!.pending
                              : AppLocalizations.of(context)!.rejected,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      )
                  ],
                ),
              ),
              if (widget.product.images.isNotEmpty)
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null &&
                        details.primaryVelocity! > 0) {
                      if (selectedIndex > 0) {
                        changeIndex(selectedIndex - 1);
                      }
                    } else if (details.primaryVelocity != null &&
                        details.primaryVelocity! < 0) {
                      if (selectedIndex < widget.product.images.length - 1) {
                        changeIndex(selectedIndex + 1);
                      }
                    }
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        minHeight: 350),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          width: 0.65,
                        ),
                      ),
                      child: Stack(
                        children: [
                          ShowImage(
                              image: widget
                                  .product.images[selectedIndex].imageUri),
                          if (widget.product.createdAt.isAfter(
                              DateTime.now().subtract(const Duration(days: 7))))
                            Positioned(
                              top: 10,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.xSmallSize - 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                          if (widget.product.images.length > 1)
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int index = 0;
                                        index < widget.product.images.length;
                                        index++)
                                      GestureDetector(
                                        onTap: () {
                                          changeIndex(index);
                                        },
                                        child: Container(
                                          width:
                                              selectedIndex == index ? 32 : 24,
                                          height:
                                              selectedIndex == index ? 32 : 24,
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
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            backgroundImage: NetworkImage(
                                              widget.product.images[index]
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
                                  timeago.format(widget.product.createdAt),
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
                                  widget.product.isNegotiable
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
                              if (widget.product.isDeliverable)
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
                                    AppLocalizations.of(context)!.deliverable,
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
                              if (widget.product.inStock)
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
                            Captilizations.capitalizeFirstOfEach(
                                widget.product.title),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'ETB ${widget.product.price}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          Text(
                            '${widget.product.shopInfo.subLocality.isEmpty ? '' : '${widget.product.shopInfo.subLocality} | '}${widget.product.shopInfo.subAdministrativeArea}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.smallSize),
                      BlocListener<ShopBloc, ShopState>(
                        listener: (context, state) {
                          if (state.favoriteProductsStatus ==
                              FavoriteProductsStatus.failure) {
                            setState(() {
                              isFavourite = !isFavourite;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            // favorite
                            GestureDetector(
                              onTap: () {
                                if (isFavourite) {
                                  setState(() {
                                    isFavourite = false;
                                  });
                                } else {
                                  setState(() {
                                    isFavourite = true;
                                  });
                                }
                                context.read<ShopBloc>().add(
                                      AddOrRemoveFavoriteProductEvent(
                                        product: widget.product,
                                        token: context
                                                .read<UserBloc>()
                                                .state
                                                .user!
                                                .token ??
                                            '',
                                      ),
                                    );
                              },
                              child: Container(
                                width: 60,
                                height: 60,
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
                                child: Icon(
                                  isFavourite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavourite
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSize.smallSize),
                            // share
                            GestureDetector(
                              onTap: () => shareContent(
                                  context, widget.product.shopInfo),
                              child: Container(
                                width: 60,
                                height: 60,
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
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSize.smallSize),
                            // call
                            GestureDetector(
                              onTap: () => makePhoneCall(
                                  widget.product.shopInfo.phoneNumber),
                              child: Container(
                                width: 60,
                                height: 60,
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
                                child: const Icon(
                                  Icons.call,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            // message
                            const SizedBox(width: AppSize.smallSize),
                            if (widget.product.shopInfo.id !=
                                    context.read<UserBloc>().state.user!.id &&
                                widget.product.productApprovalStatus == 2)
                              GestureDetector(
                                onTap: () {
                                  PersistentNavBarNavigator
                                      .pushNewScreenWithRouteSettings(
                                    context,
                                    settings: const RouteSettings(
                                        name: '/shop/message'),
                                    withNavBar: false,
                                    screen: ChatPage(
                                      receiver: ChatParticipantEntity(
                                          id: widget.product.shopInfo.id,
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
                                  width: 60,
                                  height: 60,
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
                                  child: const Icon(
                                    Icons.message,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),

                            if (widget.product.shopInfo.id ==
                                    context.watch<UserBloc>().state.user!.id &&
                                context.watch<UserBloc>().state.tiktoker !=
                                    null)
                              GestureDetector(
                                onTap: () {
                                  PersistentNavBarNavigator
                                      .pushNewScreenWithRouteSettings(
                                    context,
                                    settings: const RouteSettings(
                                        name: '/shop/message'),
                                    withNavBar: false,
                                    screen: UploadToTiktok(
                                      product: widget.product,
                                    ),
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.fade,
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
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
                                  child: Icon(
                                    Icons.tiktok_outlined,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (widget.product.description.isNotEmpty)
                        const SizedBox(height: AppSize.smallSize),
                      if (widget.product.description.isNotEmpty)
                        builderDetails(
                          AppLocalizations.of(context)!
                              .productDetailDescription,
                          Text(
                            widget.product.description,
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
                      if (widget.product.colors.isNotEmpty)
                        builderDetails(
                          AppLocalizations.of(context)!.productDetailColor,
                          Wrap(
                            spacing: AppSize.mediumSize,
                            runSpacing: AppSize.smallSize,
                            children: [
                              for (int index = 0;
                                  index < widget.product.colors.length;
                                  index++)
                                Column(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          width: 0.75,
                                        ),
                                        color: Color(int.parse(
                                          "FF${widget.product.colors[index].hexCode.substring(1)}",
                                          radix: 16,
                                        )),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    const SizedBox(height: AppSize.xxSmallSize),
                                    Text(
                                      Captilizations.capitalize(
                                          LocalizationMap.getColorMap(
                                              context,
                                              widget
                                                  .product.colors[index].name)),
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
                      if (widget.product.colors.isNotEmpty)
                        const SizedBox(height: AppSize.smallSize),
                      if (widget.product.sizes.isNotEmpty)
                        builderDetails(
                          AppLocalizations.of(context)!.productDetailSize,
                          Wrap(
                            spacing: AppSize.mediumSize,
                            runSpacing: AppSize.smallSize,
                            children: [
                              for (int index = 0;
                                  index < widget.product.sizes.length;
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
                                      widget.product.sizes[index].abbreviation
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
                      if (widget.product.sizes.isNotEmpty)
                        const SizedBox(height: AppSize.smallSize),
                      // if (widget.product.brands.isNotEmpty)
                      //   builderDetails(
                      //     AppLocalizations.of(context)!.productDetailBrand,
                      //     Wrap(
                      //       spacing: AppSize.mediumSize,
                      //       runSpacing: AppSize.smallSize,
                      //       children: [
                      //         for (int index = 0;
                      //             index < widget.product.brands.length;
                      //             index++)
                      //           Container(
                      //             padding: const EdgeInsets.symmetric(
                      //               horizontal: AppSize.xSmallSize,
                      //               vertical: AppSize.xxSmallSize,
                      //             ),
                      //             decoration: BoxDecoration(
                      //               border: Border.all(
                      //                 color: Theme.of(context)
                      //                     .colorScheme
                      //                     .primaryContainer,
                      //               ),
                      //               color: Theme.of(context)
                      //                   .colorScheme
                      //                   .primaryContainer,
                      //               borderRadius: const BorderRadius.all(
                      //                 Radius.circular(AppSize.xxSmallSize),
                      //               ),
                      //             ),
                      //             child: Text(
                      //               Captilizations.capitalize(
                      //                   Captilizations.capitalize(
                      //                 LocalizationMap.getBrandMap(
                      //                     context,
                      //                     widget.product.brands[index].name
                      //                         .toLowerCase()),
                      //               )),
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .bodyMedium!
                      //                   .copyWith(
                      //                       color: Theme.of(context)
                      //                           .colorScheme
                      //                           .secondary),
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   ),

                      // if (widget.product.brands.isNotEmpty)
                      //   const SizedBox(height: AppSize.smallSize),
                      // if (widget.product.designs.isNotEmpty)
                      //   builderDetails(
                      //     AppLocalizations.of(context)!.productDetailDesign,
                      //     Wrap(
                      //       spacing: AppSize.mediumSize,
                      //       runSpacing: AppSize.smallSize,
                      //       children: [
                      //         for (int index = 0;
                      //             index < widget.product.designs.length;
                      //             index++)
                      //           Container(
                      //             padding: const EdgeInsets.symmetric(
                      //               horizontal: AppSize.xSmallSize,
                      //               vertical: AppSize.xxSmallSize,
                      //             ),
                      //             decoration: BoxDecoration(
                      //               border: Border.all(
                      //                 color: Theme.of(context)
                      //                     .colorScheme
                      //                     .primaryContainer,
                      //               ),
                      //               color: Theme.of(context)
                      //                   .colorScheme
                      //                   .primaryContainer,
                      //               borderRadius: const BorderRadius.all(
                      //                 Radius.circular(AppSize.xxSmallSize),
                      //               ),
                      //             ),
                      //             child: Text(
                      //               Captilizations.capitalize(
                      //                   LocalizationMap.getDesignMap(
                      //                       context,
                      //                       widget
                      //                           .product.designs[index].name)),
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .bodyMedium!
                      //                   .copyWith(
                      //                       color: Theme.of(context)
                      //                           .colorScheme
                      //                           .secondary),
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   ),

                      // if (widget.product.designs.isNotEmpty)
                      //   const SizedBox(height: AppSize.smallSize),
                      // if (widget.product.materials.isNotEmpty)
                      //   builderDetails(
                      //     AppLocalizations.of(context)!.productDetailMaterial,
                      //     Wrap(
                      //       spacing: AppSize.mediumSize,
                      //       runSpacing: AppSize.smallSize,
                      //       children: [
                      //         for (int index = 0;
                      //             index < widget.product.materials.length;
                      //             index++)
                      //           Container(
                      //             padding: const EdgeInsets.symmetric(
                      //               horizontal: AppSize.xSmallSize,
                      //               vertical: AppSize.xxSmallSize,
                      //             ),
                      //             decoration: BoxDecoration(
                      //               border: Border.all(
                      //                 color: Theme.of(context)
                      //                     .colorScheme
                      //                     .primaryContainer,
                      //               ),
                      //               color: Theme.of(context)
                      //                   .colorScheme
                      //                   .primaryContainer,
                      //               borderRadius: const BorderRadius.all(
                      //                 Radius.circular(AppSize.xxSmallSize),
                      //               ),
                      //             ),
                      //             child: Text(
                      //               Captilizations.capitalize(
                      //                   LocalizationMap.getMaterialMap(
                      //                       context,
                      //                       widget.product.materials[index]
                      //                           .name)),
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .bodyMedium!
                      //                   .copyWith(
                      //                       color: Theme.of(context)
                      //                           .colorScheme
                      //                           .secondary),
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   ),

                      // if (widget.product.materials.isNotEmpty)
                      //   const SizedBox(height: AppSize.smallSize),
                      if (widget.showShop)
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppSize.xSmallSize)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        widget.product.shopInfo.logo,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.product.shopInfo.name.substring(
                                            0,
                                            min(
                                                8,
                                                widget.product.shopInfo.name
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
                                        widget.product.shopInfo
                                            .subAdministrativeArea
                                            .substring(
                                                0,
                                                min(
                                                    14,
                                                    widget
                                                        .product
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
                                        shopId: widget.product.shopInfo.id),
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.fade,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
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
        ),
      ),
    );
  }
}
