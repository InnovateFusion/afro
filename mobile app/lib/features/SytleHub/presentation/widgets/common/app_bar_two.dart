import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/notification/notification_bloc.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../pages/create_shop.dart';
import '../../pages/my_shop.dart';
import '../../pages/notification_screen.dart';

class AppBarTwo extends StatelessWidget {
  const AppBarTwo({
    required this.onTap,
    this.isColorWhite = false,
    super.key,
  });
  final Function() onTap;
  final bool isColorWhite;

  @override
  Widget build(BuildContext context) {
    String imageLink = '';
    if (context.watch<UserBloc>().state.user != null) {
      imageLink = context.watch<UserBloc>().state.user!.profilePicture ?? '';
    }

    var shop = context.watch<ShopBloc>().state;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (context.read<UserBloc>().state.user != null) {
              onTap();
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            clipBehavior: Clip.hardEdge,
            child: imageLink.isNotEmpty
                ? Image.network(
                    imageLink,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/Screens/person.png",
                      );
                    },
                  )
                : Image.asset(
                    "assets/images/Screens/person.png",
                  ),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            if ((context.watch<ShopBloc>().state.shopMyProductsStatus ==
                    ShopMyProductsStatus.loading &&
                shop.myShopId == null))
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSize.mediumSize),
                ),
                height: 44,
                width: 130,
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  if (shop.myShopId != null &&
                      shop.deleteShopStatus == DeleteShopStatus.initial &&
                      shop.shopMyProductsStatus ==
                          ShopMyProductsStatus.success) {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(name: '/my_shop'),
                      withNavBar: false,
                      screen: const MyShopScreen(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  } else {
                    if (context.read<UserBloc>().state.user?.isEmailVerified ==
                        true) {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: const RouteSettings(name: '/shop/create'),
                        withNavBar: false,
                        screen: const CreateShop(),
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 3),
                          content: Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .verify_email_request,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Same border radius
                  ),
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: Icon(
                  Icons.storefront,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                label: Text(
                  AppLocalizations.of(context)!.appBarTwoMyShop,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            const SizedBox(width: AppSize.smallSize),
            GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: const RouteSettings(name: '/notification'),
                  withNavBar: false,
                  screen: const NotificationScreen(),
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSize.xSmallSize),
                child: Stack(
                  children: [
                    (Theme.of(context).brightness == Brightness.dark ||
                            isColorWhite)
                        ? SvgPicture.asset(
                            "assets/icons/notifaction_dark.svg",
                            height: 32,
                          )
                        : SvgPicture.asset(
                            "assets/icons/notifaction.svg",
                            height: 32,
                          ),
                    if (context.watch<NotificationBloc>().state.unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            context
                                        .watch<NotificationBloc>()
                                        .state
                                        .unreadCount >
                                    9
                                ? "9+"
                                : context
                                    .watch<NotificationBloc>()
                                    .state
                                    .unreadCount
                                    .toString(),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
      ],
    );
  }
}
