import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../core/utils/enum.dart';
import '../../../../setUp/size/app_size.dart';
import '../../../shared/presentation/pages/layout.dart';
import '../bloc/auth_bloc.dart';
import 'auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(LoadCurrentUserEvent());
    context.read<AuthBloc>().add(const UpdateAccessTokenEvent());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.updateAccessTokenStatus == ApiRequestStatus.success &&
              state.loadCurrentUserStatus == ApiRequestStatus.success) {
            Future.delayed(const Duration(seconds: 2), () {
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: const RouteSettings(name: '/layout'),
                withNavBar: false,
                screen: const Layout(),
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            });
          } else if (state.loadCurrentUserStatus == ApiRequestStatus.error) {
            Future.delayed(const Duration(seconds: 2), () {
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: const RouteSettings(name: '/login'),
                withNavBar: false,
                screen: const Auth(),
                pageTransitionAnimation: PageTransitionAnimation.fade,
              );
            });
          }
        },
        child: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.primary,
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
