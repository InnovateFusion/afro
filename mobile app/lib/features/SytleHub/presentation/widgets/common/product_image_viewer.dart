import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:style_hub/features/SytleHub/domain/entities/product/product_entity.dart';
import 'package:style_hub/features/SytleHub/presentation/pages/chat_detail.dart';
import 'package:style_hub/features/SytleHub/presentation/pages/product_detail.dart';
import 'package:style_hub/features/SytleHub/presentation/pages/shop_detail.dart';
import 'package:style_hub/setUp/size/app_size.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/captilizations.dart';
import '../../../domain/entities/chat/chat_participant_entity.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import 'show_image.dart';

class ProductImageViewer extends StatefulWidget {
  final ProductEntity product;

  const ProductImageViewer({
    super.key,
    required this.product,
  });

  @override
  State<ProductImageViewer> createState() => _ProductImageViewerState();
}

class _ProductImageViewerState extends State<ProductImageViewer> {
  int selectedIndex = 0;

  void changeIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.product.images.length) {
      setState(() {
        selectedIndex = newIndex;
      });
    }
  }

  Future<void> shareContent(BuildContext context, ProductEntity product) async {
    final uri = Uri(scheme: "google.navigation", queryParameters: {
      'q': '${product.shopInfo.latitude}, ${product.shopInfo.longitude}'
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

  @override
  Widget build(BuildContext context) {
    if (widget.product.images.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Center(
          child: Icon(
            Icons.broken_image,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0) {
            // Swipe right
            changeIndex(selectedIndex - 1);
          } else if (details.primaryVelocity! < 0) {
            // Swipe left
            changeIndex(selectedIndex + 1);
          }
        }
      },
      onTap: () {
        if (selectedIndex < widget.product.images.length) {
          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
            context,
            settings: const RouteSettings(name: '/product/detail'),
            withNavBar: false,
            screen: ProductDetail(
              product: widget.product,
              showShop: true,
            ),
            pageTransitionAnimation: PageTransitionAnimation.fade,
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                ),
                child: (selectedIndex < widget.product.images.length)
                    ? ShowImage(
                        image: widget.product.images[selectedIndex].imageUri)
                    : null,
              ),
            ),
            Positioned(
              right: AppSize.xxSmallSize,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: '/shop/detail'),
                          withNavBar: false,
                          screen: ShopDetail(
                            shopId: widget.product.shopInfo.id,
                          ),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppSize.xxxLargeSize),
                          border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            width: 1.0,
                          ),
                        ),
                        child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.product.shopInfo.logo)),
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    GestureDetector(
                      onTap: () {
                        final userId = widget.product.shopInfo.id;
                        if (userId == context.read<UserBloc>().state.user!.id) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .shopDetail_messageError,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          );
                          return;
                        }
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: '/shop/message'),
                          withNavBar: false,
                          screen: ChatPage(
                            receiver: ChatParticipantEntity(
                                id: userId,
                                firstName: '',
                                lastName: '',
                                email: '',
                                chatEntities: const []),
                          ),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.message,
                            color: Theme.of(context).colorScheme.primary,
                            size: AppSize.largeSize,
                          ),
                          Text(
                            Captilizations.capitalizeFirstOfEach(
                              AppLocalizations.of(context)!.message,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 9,
                                    height: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    GestureDetector(
                      onTap: () => context.read<ShopBloc>().add(
                            AddOrRemoveFavoriteProductEvent(
                              product: widget.product,
                              token:
                                  context.read<UserBloc>().state.user!.token ??
                                      '',
                            ),
                          ),
                      child: Column(
                        children: [
                          Icon(
                            widget.product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.error,
                            size: AppSize.largeSize,
                          ),
                          Text(
                            Captilizations.capitalizeFirstOfEach(
                              AppLocalizations.of(context)!.favorite,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 9,
                                    height: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    GestureDetector(
                      onTap: () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: widget.product.shopInfo.phoneNumber,
                        );
                        await launchUrl(launchUri);
                      },
                      child: Column(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.greenAccent,
                            size: AppSize.largeSize,
                          ),
                          Text(
                            Captilizations.capitalizeFirstOfEach(
                              AppLocalizations.of(context)!.phone,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 9,
                                    height: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    GestureDetector(
                      onTap: () => shareContent(context, widget.product),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.blueAccent,
                            size: AppSize.largeSize,
                          ),
                          Text(
                            Captilizations.capitalizeFirstOfEach(
                              AppLocalizations.of(context)!.location,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 9,
                                    height: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.product.images.isNotEmpty)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8, // Space between thumbnails
                    children: [
                      for (int index = 0;
                          index < widget.product.images.length;
                          index++)
                        GestureDetector(
                          onTap: () => changeIndex(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: selectedIndex == index ? 28 : 20,
                            height: selectedIndex == index ? 28 : 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 1.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                widget.product.images[index].imageUri,
                              ),
                              onBackgroundImageError: (_, __) => Icon(
                                Icons.broken_image,
                                color: Theme.of(context).colorScheme.error,
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
    );
  }
}
