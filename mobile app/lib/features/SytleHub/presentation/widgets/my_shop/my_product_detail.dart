import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../pages/edit_product.dart';
import '../../pages/upload_to_tiktok.dart';
import '../common/app_bar_one.dart';
import '../common/show_image.dart';
import 'product_chat_analytic.dart';
import 'shop_analytics.dart';

class MyProductDetail extends StatefulWidget {
  const MyProductDetail(
      {super.key, required this.product, this.displayButton = 0});
  final ProductEntity product;
  final int displayButton;

  @override
  State<MyProductDetail> createState() => _MyProductDetailState();
}

class _MyProductDetailState extends State<MyProductDetail> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isFavourite = false;
  List uniqueImages = [];

  @override
  void initState() {
    super.initState();
    isFavourite = widget.product.isFavorite;
    context.read<ShopBloc>().add(GetShopProductByIdEvent(
        id: widget.product.id,
        token: context.read<UserBloc>().state.user?.token ?? ''));
    context.read<ShopBloc>().add(GetProductAnalyticEvent(
        id: widget.product.id,
        token: context.read<UserBloc>().state.user?.token ?? ''));
    uniqueImages = widget.product.images.toSet().toList();
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.xSmallSize),
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: AppSize.xSmallSize),
              Text(
                AppLocalizations.of(context)!.deleteProduct, // Localized text
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteConfirmation, // Localized text
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              child:
                  Text(AppLocalizations.of(context)!.cancel), // Localized text
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ShopBloc>().add(
                      DeleteProductEvent(
                        product: product,
                        token: context.read<UserBloc>().state.user!.token ?? '',
                      ),
                    );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.delete, // Localized text
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        );
      },
    );
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

    void changeIndex(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    final Map<String, String> colorNameMap = {
      'beige': AppLocalizations.of(context)!.color_beige,
      'black': AppLocalizations.of(context)!.color_black,
      'blue': AppLocalizations.of(context)!.color_blue,
      'blush pink': AppLocalizations.of(context)!.color_blush_pink,
      'brown': AppLocalizations.of(context)!.color_brown,
      'burgundy': AppLocalizations.of(context)!.color_burgundy,
      'champagne': AppLocalizations.of(context)!.color_champagne,
      'charcoal': AppLocalizations.of(context)!.color_charcoal,
      'cobalt blue': AppLocalizations.of(context)!.color_cobalt_blue,
      'coral': AppLocalizations.of(context)!.color_coral,
      'coral red': AppLocalizations.of(context)!.color_coral_red,
      'cream': AppLocalizations.of(context)!.color_cream,
      'crimson': AppLocalizations.of(context)!.color_crimson,
      'emerald green': AppLocalizations.of(context)!.color_emerald_green,
      'gold': AppLocalizations.of(context)!.color_gold,
      'gray': AppLocalizations.of(context)!.color_gray,
      'green': AppLocalizations.of(context)!.color_green,
      'indigo': AppLocalizations.of(context)!.color_indigo,
      'ivory': AppLocalizations.of(context)!.color_ivory,
      'khaki': AppLocalizations.of(context)!.color_khaki,
      'lavender': AppLocalizations.of(context)!.color_lavender,
      'maroon': AppLocalizations.of(context)!.color_maroon,
      'mauve': AppLocalizations.of(context)!.color_mauve,
      'midnight blue': AppLocalizations.of(context)!.color_midnight_blue,
      'mint green': AppLocalizations.of(context)!.color_mint_green,
      'mustard yellow': AppLocalizations.of(context)!.color_mustard_yellow,
      'navy blue': AppLocalizations.of(context)!.color_navy_blue,
      'neon green': AppLocalizations.of(context)!.color_neon_green,
      'olive': AppLocalizations.of(context)!.color_olive,
      'orange': AppLocalizations.of(context)!.color_orange,
      'pastel peach': AppLocalizations.of(context)!.color_pastel_peach,
      'pink': AppLocalizations.of(context)!.color_pink,
      'platinum': AppLocalizations.of(context)!.color_platinum,
      'purple': AppLocalizations.of(context)!.color_purple,
      'red': AppLocalizations.of(context)!.color_red,
      'rose gold': AppLocalizations.of(context)!.color_rose_gold,
      'rust': AppLocalizations.of(context)!.color_rust,
      'sapphire blue': AppLocalizations.of(context)!.color_sapphire_blue,
      'silver': AppLocalizations.of(context)!.color_silver,
      'slate': AppLocalizations.of(context)!.color_slate,
      'tan': AppLocalizations.of(context)!.color_tan,
      'teal': AppLocalizations.of(context)!.color_teal,
      'turquoise': AppLocalizations.of(context)!.color_turquoise,
      'white': AppLocalizations.of(context)!.color_white,
      'yellow': AppLocalizations.of(context)!.color_yellow,
    };

    return SafeArea(
      child: (context.watch<ShopBloc>().state.productAnalyticStatus ==
                  ProductAnalyticStatus.success &&
              context
                  .watch<ShopBloc>()
                  .state
                  .analyticProductEntity
                  .thisMonthViews
                  .isNotEmpty)
          ? Scaffold(
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
                          Row(
                            children: [
                              if (context
                                          .watch<ShopBloc>()
                                          .state
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
                                          .productApprovalStatus ==
                                      1 ||
                                  context
                                          .watch<ShopBloc>()
                                          .state
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
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
                                                .shops[
                                                    widget.product.shopInfo.id]!
                                                .products[widget.product.id]!
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
                                                .shops[
                                                    widget.product.shopInfo.id]!
                                                .products[widget.product.id]!
                                                .productApprovalStatus ==
                                            1
                                        ? AppLocalizations.of(context)!.pending
                                        : AppLocalizations.of(context)!
                                            .rejected,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                  ),
                                ),
                              if (context
                                          .watch<ShopBloc>()
                                          .state
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
                                          .shopInfo
                                          .id ==
                                      context
                                          .watch<UserBloc>()
                                          .state
                                          .user!
                                          .id &&
                                  context.watch<UserBloc>().state.tiktoker !=
                                      null &&
                                  context
                                          .watch<ShopBloc>()
                                          .state
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
                                          .productApprovalStatus ==
                                      2)
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppSize.xSmallSize,
                                        horizontal: AppSize.smallSize),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(AppSize.mediumSize),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.tiktok_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        const SizedBox(
                                            width: AppSize.xSmallSize),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .share_to_tiktok,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(width: AppSize.xxSmallSize),
                              PopupMenuButton<String>(
                                surfaceTintColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                color: Theme.of(context).colorScheme.onPrimary,
                                shadowColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      if (widget.displayButton == 0) {
                                        context.read<ShopBloc>().add(
                                              ArchiveProductEvent(
                                                token: context
                                                        .read<UserBloc>()
                                                        .state
                                                        .user!
                                                        .token ??
                                                    '',
                                                product: widget.product,
                                              ),
                                            );
                                      } else if (widget.displayButton == 1) {
                                        context.read<ShopBloc>().add(
                                              UnArchiveProductEvent(
                                                token: context
                                                        .read<UserBloc>()
                                                        .state
                                                        .user!
                                                        .token ??
                                                    '',
                                                product: widget.product,
                                              ),
                                            );
                                      } else {
                                        context.read<ShopBloc>().add(
                                              UnDraftProductEvent(
                                                token: context
                                                        .read<UserBloc>()
                                                        .state
                                                        .user!
                                                        .token ??
                                                    '',
                                                product: widget.product,
                                              ),
                                            );
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                            widget.displayButton == 0
                                                ? Icons.archive
                                                : widget.displayButton == 1
                                                    ? Icons.unarchive
                                                    : Icons.publish,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        const SizedBox(
                                            width: AppSize.xSmallSize),
                                        Text(
                                            widget.displayButton == 0
                                                ? AppLocalizations.of(context)!
                                                    .archiveProduct
                                                : widget.displayButton == 1
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .unarchiveProduct
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .publishProduct,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      PersistentNavBarNavigator
                                          .pushNewScreenWithRouteSettings(
                                        context,
                                        settings: const RouteSettings(
                                            name: '/product/edit'),
                                        withNavBar: false,
                                        screen: EditProductScreen(
                                          product: widget.product,
                                        ),
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        const SizedBox(
                                            width: AppSize.xSmallSize),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .editProduct,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      _showDeleteConfirmationDialog(
                                          context, widget.product);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        const SizedBox(
                                            width: AppSize.xSmallSize),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .deleteProduct,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (context
                        .watch<ShopBloc>()
                        .state
                        .shops[widget.product.shopInfo.id]!
                        .products[widget.product.id]!
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
                                widget.product.images.length - 1) {
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
                                        .shops[widget.product.shopInfo.id]!
                                        .products[widget.product.id]!
                                        .images[selectedIndex]
                                        .imageUri),
                                if (context
                                    .watch<ShopBloc>()
                                    .state
                                    .shops[widget.product.shopInfo.id]!
                                    .products[widget.product.id]!
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
                                            .newTag, // Localized text
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
                                if (uniqueImages.length > 1)
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
                                              index < uniqueImages.length;
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
                                                    uniqueImages[index]
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
                                      timeago.format(context
                                          .watch<ShopBloc>()
                                          .state
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
                                          .createdAt),
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
                                              .shops[
                                                  widget.product.shopInfo.id]!
                                              .products[widget.product.id]!
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
                                      .shops[widget.product.shopInfo.id]!
                                      .products[widget.product.id]!
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
                                          Radius.circular(AppSize.xxxLargeSize),
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
                                      .shops[widget.product.shopInfo.id]!
                                      .products[widget.product.id]!
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
                                Captilizations.capitalize(context
                                    .watch<ShopBloc>()
                                    .state
                                    .shops[widget.product.shopInfo.id]!
                                    .products[widget.product.id]!
                                    .title),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'ETB ${context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                              Text(
                                '${context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.shopInfo.subLocality.isEmpty ? '' : Captilizations.capitalize('${context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.shopInfo.subLocality} | ')} ${Captilizations.capitalize(context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.shopInfo.subAdministrativeArea)}',
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
                          builderDetails(
                            AppLocalizations.of(context)!
                                .productAnalytics, // Localized text
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnalyticsItem(
                                      icon: Icons.favorite,
                                      label: AppLocalizations.of(context)!
                                          .favorites,
                                      value: context
                                          .read<ShopBloc>()
                                          .state
                                          .analyticProductEntity
                                          .totalFavorites,
                                    ),
                                    const SizedBox(width: AppSize.smallSize),
                                    AnalyticsItem(
                                      icon: Icons.contact_mail,
                                      label: AppLocalizations.of(context)!
                                          .analyticsCard_impressions,
                                      value: context
                                          .read<ShopBloc>()
                                          .state
                                          .analyticProductEntity
                                          .totalContacted,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSize.smallSize),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnalyticsItem(
                                      icon: Icons.remove_red_eye,
                                      label: AppLocalizations.of(context)!
                                          .dailyView, // Localized text
                                      value: context
                                          .read<ShopBloc>()
                                          .state
                                          .analyticProductEntity
                                          .todayViews,
                                    ),
                                    const SizedBox(width: AppSize.smallSize),
                                    AnalyticsItem(
                                      icon: Icons.visibility,
                                      label: AppLocalizations.of(context)!
                                          .views, // Localized text
                                      value: context
                                          .read<ShopBloc>()
                                          .state
                                          .analyticProductEntity
                                          .totalViews,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.mediumSize),
                        height: 450,
                        child: ChartScreen(
                          analytics: context
                              .watch<ShopBloc>()
                              .state
                              .analyticProductEntity,
                        )),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSize.smallSize),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (context
                              .watch<ShopBloc>()
                              .state
                              .shops[widget.product.shopInfo.id]!
                              .products[widget.product.id]!
                              .description
                              .isNotEmpty)
                            builderDetails(
                              AppLocalizations.of(context)!
                                  .productDetailDescription,
                              Text(
                                context
                                    .watch<ShopBloc>()
                                    .state
                                    .shops[widget.product.shopInfo.id]!
                                    .products[widget.product.id]!
                                    .description,
                                textAlign: TextAlign.justify,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ),
                          const SizedBox(height: AppSize.smallSize),
                          if (context
                              .watch<ShopBloc>()
                              .state
                              .shops[widget.product.shopInfo.id]!
                              .products[widget.product.id]!
                              .colors
                              .isNotEmpty)
                            builderDetails(
                              AppLocalizations.of(context)!
                                  .color, // Localized text
                              Wrap(
                                spacing: AppSize.mediumSize,
                                runSpacing: AppSize.smallSize,
                                children: [
                                  for (int index = 0;
                                      index <
                                          context
                                              .watch<ShopBloc>()
                                              .state
                                              .shops[
                                                  widget.product.shopInfo.id]!
                                              .products[widget.product.id]!
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
                                              "FF${context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.colors[index].hexCode.substring(1)}",
                                              radix: 16,
                                            )),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              width: 0.75,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: AppSize.xxSmallSize),
                                        Text(
                                          Captilizations.capitalize(
                                              colorNameMap[context
                                                      .watch<ShopBloc>()
                                                      .state
                                                      .shops[widget
                                                          .product.shopInfo.id]!
                                                      .products[
                                                          widget.product.id]!
                                                      .colors[index]
                                                      .name] ??
                                                  context
                                                      .watch<ShopBloc>()
                                                      .state
                                                      .shops[widget
                                                          .product.shopInfo.id]!
                                                      .products[
                                                          widget.product.id]!
                                                      .colors[index]
                                                      .name),
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
                              .shops[widget.product.shopInfo.id]!
                              .products[widget.product.id]!
                              .colors
                              .isNotEmpty)
                            const SizedBox(height: AppSize.smallSize),
                          if (context
                              .watch<ShopBloc>()
                              .state
                              .shops[widget.product.shopInfo.id]!
                              .products[widget.product.id]!
                              .sizes
                              .isNotEmpty)
                            builderDetails(
                              AppLocalizations.of(context)!
                                  .size, // Localized text
                              Wrap(
                                spacing: AppSize.mediumSize,
                                runSpacing: AppSize.smallSize,
                                children: [
                                  for (int index = 0;
                                      index <
                                          context
                                              .watch<ShopBloc>()
                                              .state
                                              .shops[
                                                  widget.product.shopInfo.id]!
                                              .products[widget.product.id]!
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
                                          widget
                                              .product.sizes[index].abbreviation
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
                              .shops[widget.product.shopInfo.id]!
                              .products[widget.product.id]!
                              .sizes
                              .isNotEmpty)
                            const SizedBox(height: AppSize.smallSize),
                          // if (context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.brands.isNotEmpty)
                          //   builderDetails(
                          //     AppLocalizations.of(context)!
                          //         .brand, // Localized text
                          //     Wrap(
                          //       spacing: AppSize.mediumSize,
                          //       runSpacing: AppSize.smallSize,
                          //       children: [
                          //         for (int index = 0;
                          //             index < context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.brands.length;
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
                          //                     context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.brands[index].name
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
                          // if (context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.brands.isNotEmpty)
                          //   const SizedBox(height: AppSize.smallSize),
                          // if (context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.designs.isNotEmpty)
                          //   builderDetails(
                          //     AppLocalizations.of(context)!
                          //         .design, // Localized text
                          //     Wrap(
                          //       spacing: AppSize.mediumSize,
                          //       runSpacing: AppSize.smallSize,
                          //       children: [
                          //         for (int index = 0;
                          //             index < context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.designs.length;
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
                          //               Captilizations.capitalize(designNameMap[
                          //                       context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.designs[index]
                          //                           .name] ??
                          //                   context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.designs[index].name),
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
                          // if (context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.designs.isNotEmpty)
                          //   const SizedBox(height: AppSize.smallSize),
                          // if (context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.materials.isNotEmpty)
                          //   builderDetails(
                          //     AppLocalizations.of(context)!
                          //         .material, // Localized text
                          //     Wrap(
                          //       spacing: AppSize.mediumSize,
                          //       runSpacing: AppSize.smallSize,
                          //       children: [
                          //         for (int index = 0;
                          //             index < context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.materials.length;
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
                          //                 LocalizationMap.getMaterialMap(
                          //                     context,
                          //                     context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.materials[index]
                          //                         .name),
                          //               ),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const AppBarOne(),
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
                                          .watch<ShopBloc>()
                                          .state
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
                                          .images
                                          .length -
                                      1) {
                                changeIndex(selectedIndex + 1);
                              }
                            }
                          },
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 300),
                            child: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Stack(
                                children: [
                                  ShowImage(
                                      image: context
                                          .watch<ShopBloc>()
                                          .state
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
                                          .images[selectedIndex]
                                          .imageUri),
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
                                            .newTag, // Localized text
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
                                          .shops[widget.product.shopInfo.id]!
                                          .products[widget.product.id]!
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
                                                    widget
                                                        .product.images.length;
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
                                                  ),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      widget
                                                          .product
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
                                  Text(
                                    Captilizations.capitalize(context
                                        .watch<ShopBloc>()
                                        .state
                                        .shops[widget.product.shopInfo.id]!
                                        .products[widget.product.id]!
                                        .title),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  Text(
                                    'ETB ${context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                  Text(
                                    '${context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.shopInfo.subLocality.isEmpty ? '' : Captilizations.capitalize('${context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.shopInfo.subLocality} | ')} ${Captilizations.capitalize(context.watch<ShopBloc>().state.shops[widget.product.shopInfo.id]!.products[widget.product.id]!.shopInfo.subAdministrativeArea)}',
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
                              builderDetails(
                                AppLocalizations.of(context)!
                                    .productAnalytics, // Localized text
                                const Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AnalyticsItem(
                                          icon: Icons.favorite,
                                          label: "Favorites",
                                          value: 0,
                                        ),
                                        SizedBox(width: AppSize.smallSize),
                                        AnalyticsItem(
                                          icon: Icons.contact_mail,
                                          label: "Contacts",
                                          value: 0,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppSize.smallSize),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AnalyticsItem(
                                          icon: Icons.remove_red_eye,
                                          label: "Daily View",
                                          value: 0,
                                        ),
                                        SizedBox(width: AppSize.smallSize),
                                        AnalyticsItem(
                                          icon: Icons.visibility,
                                          label: "Views",
                                          value: 0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
    );
  }
}
