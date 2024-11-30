import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/url/urls.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/notification/notification_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/scroll/scroll_bloc.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/no_internet_connection.dart';
import '../widgets/preference/main_stepper.dart';
import '../widgets/preference/update_app_version.dart';
import 'category.dart';
import 'chat.dart';
import 'drawer.dart';
import 'home.dart';
import 'scroll_like_tiktok_for_images.dart';
import 'shop.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LayoutState();
  }
}

class _LayoutState extends State<Layout> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    context.read<ChatBloc>().add(ClearChatEvent());
    context.read<NotificationBloc>().add(ClearNotificationsEvent());
    context.read<ShopBloc>().add(const ClearShopEvent());
    context.read<ProductBloc>().add(GetDomainsEvent());
    context
        .read<ChatBloc>()
        .add(SetCurrentUserEvent(user: context.read<UserBloc>().state.user));

    context.read<ScrollBloc>().add(ScrollEventInitial());

    context.read<ShopBloc>().add(GetMyShopEvent(
          userId: context.read<UserBloc>().state.user?.id ?? '',
        ));

    context.read<ProductBloc>().add(GetColorsEvent());
    context.read<ProductBloc>().add(GetBrandsEvent());
    context.read<ProductBloc>().add(GetMaterialsEvent());
    context.read<ProductBloc>().add(GetSizesEvent());
    context.read<ProductBloc>().add(GetCategoriesEvent());
    context.read<ProductBloc>().add(GetLocationsEvent());
    context.read<ProductBloc>().add(GetDesignsEvent());

    context.read<NotificationBloc>().add(GetNotificationsEvent(
        token: context.read<UserBloc>().state.user?.token ?? ''));
    context.read<ShopBloc>().add(GetAllShopEvent(
        verified: 2, token: context.read<UserBloc>().state.user?.token ?? ''));
    context.read<ShopBloc>().add(GetFavoriteProductsEvent(
        token: context.read<UserBloc>().state.user?.token ?? ''));
    context.read<ShopBloc>().add(GetArchivedProductsEvent(
        token: context.read<UserBloc>().state.user?.token ?? ''));
    context.read<ShopBloc>().add(GetDraftProductsEvent(
        token: context.read<UserBloc>().state.user?.token ?? ''));
    context.read<ChatBloc>().add(GetChatParticipantsEvent(
        token: context.read<UserBloc>().state.user?.token ?? ''));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        inactiveIcon: const Icon(Icons.home_outlined),
        title: AppLocalizations.of(context)!.layoutNavBarHome,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.outline,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard_customize),
        inactiveIcon: const Icon(Icons.dashboard_customize_outlined),
        title: AppLocalizations.of(context)!.layoutNavBarCategory,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.outline,
      ),
      PersistentBottomNavBarItem(
        icon: const Image(image: AssetImage('assets/icons/product.png')),
        inactiveIcon:
            const Image(image: AssetImage('assets/icons/product.png')),
        iconSize: 50,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.outline,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.storefront_rounded),
        inactiveIcon: const Icon(Icons.storefront_outlined),
        title: AppLocalizations.of(context)!.layoutNavBarShops,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.outline,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat_bubble),
        inactiveIcon: const Icon(Icons.chat_bubble_outline),
        title: AppLocalizations.of(context)!.layoutNavBarChat,
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.outline,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(
        openCloseDrawer: openCloseDrawer,
      ),
      CategoryScreen(
        openCloseDrawer: openCloseDrawer,
      ),
      ScrollLikeTikTokForImages(
        openCloseDrawer: openCloseDrawer,
      ),
      ShopScreen(
        openCloseDrawer: openCloseDrawer,
      ),
      ChatScreen(
        openCloseDrawer: openCloseDrawer,
      ),
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openCloseDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        drawer: const CustomDrawer(),
        body: BlocListener<ShopBloc, ShopState>(
          listener: (context, state) {
            if (state.deleteShopStatus == DeleteShopStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .layoutShopDeletedSuccessfully,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
              context.read<ShopBloc>().add(const ChangeStatusToInitialEvent());
            }
          },
          child: context.watch<ChatBloc>().signalRService.isConnected == false
              ? const SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NoInternetConnection(),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    PersistentTabView(
                      context,
                      controller: _controller,
                      screens: _buildScreens(),
                      items: _navBarsItems(context),
                      confineInSafeArea: true,
                      handleAndroidBackButtonPress: true,
                      resizeToAvoidBottomInset: true,
                      stateManagement: false,
                      backgroundColor: _controller.index == 2
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.onPrimary,
                      hideNavigationBarWhenKeyboardShows: true,
                      onItemSelected: (index) {
                        setState(() {
                          _controller.index = index;
                        });
                      },
                      hideNavigationBar:
                          !context.watch<ScrollBloc>().state.isVisible,
                      popAllScreensOnTapOfSelectedTab: false,
                      popActionScreens: PopActionScreensType.all,
                      itemAnimationProperties: const ItemAnimationProperties(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      ),
                      screenTransitionAnimation:
                          const ScreenTransitionAnimation(
                        animateTabTransition: true,
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 1),
                      ),
                      navBarStyle: NavBarStyle.simple,
                    ),
                    if (context.watch<UserBloc>().state.user?.version !=
                        Urls.appVersion)
                      const UpdateAppVersion(),
                    if (context.watch<UserBloc>().state.user?.gender == null &&
                        context.watch<UserBloc>().state.user?.version ==
                            Urls.appVersion)
                      const MainStepper(),
                    if (context.watch<ShopBloc>().state.deleteShopStatus ==
                            DeleteShopStatus.loading ||
                        context.watch<UserBloc>().state.myProfileStatus ==
                            MyProfileStatus.loading)
                      Container(
                        color: Theme.of(context)
                            .colorScheme
                            .scrim
                            .withOpacity(0.95),
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
        ),
      ),
    );
  }
}
