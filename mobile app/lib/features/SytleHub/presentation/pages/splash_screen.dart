import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/service/local_cache.dart';
import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import 'auth.dart';
import 'layout.dart';
import 'onboarning.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static const platform = MethodChannel("com.example.afro_stores/auth");
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _setupAuthResultListener();
    context.read<UserBloc>().add(LoadCurrentUserEvent());
    context.read<UserBloc>().add(UpdateAccessTokenEvent());

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _setupAuthResultListener() {
    SplashScreen.platform.setMethodCallHandler((call) async {
      final calledMethod = LocalCache.getString('currentChannel');
      if (calledMethod != null) {
        () async {
          await LocalCache.remove('currentChannel');
        }();
      }

      if (calledMethod == 'authorizeTikTok') {
        context.read<UserBloc>().add(
              LoginWithTiktokEvent(accessCode: call.arguments),
            );
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: const RouteSettings(name: '/Auth'),
          withNavBar: false,
          screen: const Auth(),
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      } else if (calledMethod == 'connectWithTiktok') {
        context.read<UserBloc>().add(LoadCurrentUserEvent());
        context
            .read<UserBloc>()
            .add(ConnectToTiktokEvent(accessCode: call.arguments));
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: const RouteSettings(name: '/home'),
          withNavBar: false,
          screen: const Layout(),
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      } else if (call.method == 'authError') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Center(
              child: Text(
                  "An error occured while trying to login with Tiktok. Please try again",
                  textAlign: TextAlign.center)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      } else {
        print('Unknown method');
      }
      print(call.method);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state.loadCurrentUserStatus ==
                  LoadCurrentUserStatus.success) {
                if (state.updateAccessTokenStatus ==
                        UpdateAccessTokenStatus.success ||
                    state.loginWithTiktokStatus ==
                        LoginWithTiktokStatus.success) {
                  context.read<ShopBloc>().add(GetMyShopEvent(
                      userId: state.user?.id ?? '', token: state.user?.token));

                  Future.delayed(const Duration(seconds: 2), () {
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(name: '/home'),
                      withNavBar: false,
                      screen: const Layout(),
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  });
                } else if (state.updateAccessTokenStatus ==
                    UpdateAccessTokenStatus.failure) {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: '/onboarding'),
                    withNavBar: false,
                    screen: const OnBoarding(),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                }
              } else if (state.loadCurrentUserStatus ==
                  LoadCurrentUserStatus.failure) {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: const RouteSettings(name: '/onboarding'),
                  withNavBar: false,
                  screen: const OnBoarding(),
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              }
            },
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSize.largeSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AnimatedBuilder(
                      animation: _fadeInAnimation,
                      builder: (context, child) {
                        return Transform(
                          transform:
                              Matrix4.rotationZ(_fadeInAnimation.value * -0.05),
                          child: Image.asset(
                            'assets/icons/logo.png',
                            fit: BoxFit.contain,
                            width: 300,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSize.largeSize),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
