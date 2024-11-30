import 'package:afro_shop_admin/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/shared_widgets/no_internet_connection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/pages/home.dart';
import '../../../shop/presentation/pages/shop.dart';
import '../bloc/scroll/scroll_bloc.dart';

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
    super.initState();
    context.read<ProductBloc>().add(GetProductsEvent(
          token: context.read<AuthBloc>().state.user?.token ?? '',
        ));
    context.read<ShopBloc>().add(FetchShopsEvent(
          token: context.read<AuthBloc>().state.user?.token ?? '',
        ));
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
        title: "Home",
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.outline,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.storefront_rounded),
        inactiveIcon: const Icon(Icons.storefront_outlined),
        title: "Shop",
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.outline,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return const [
      Home(),
      Shop(),
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: context.watch<ProductBloc>().signalRService.isConnected == false
            ? const Center(
                child: NoInternetConnection(),
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
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    hideNavigationBarWhenKeyboardShows: true,
                    hideNavigationBar:
                        !context.watch<ScrollBloc>().state.isVisible,
                    popAllScreensOnTapOfSelectedTab: true,
                    popActionScreens: PopActionScreensType.all,
                    itemAnimationProperties: const ItemAnimationProperties(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    ),
                    screenTransitionAnimation: const ScreenTransitionAnimation(
                      animateTabTransition: true,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 200),
                    ),
                    navBarStyle: NavBarStyle.style1,
                  ),
                ],
              ),
      ),
    );
  }
}
