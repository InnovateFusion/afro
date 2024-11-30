import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/select_language.dart';
import 'auth.dart';
import 'connect_with_tiktok.dart';
import 'favorite.dart';
import 'my_profile.dart';
import 'notification_setting.dart';
import 'password_reset.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String imageLink = '';
    if (context.watch<UserBloc>().state.user != null) {
      imageLink = context.watch<UserBloc>().state.user!.profilePicture ?? '';
    }
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSize.xxxSmallSize),
          bottomRight: Radius.circular(AppSize.xxxSmallSize),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                    '${context.watch<UserBloc>().state.user!.firstName} ${context.watch<UserBloc>().state.user!.lastName}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                accountEmail: Text(context.watch<UserBloc>().state.user!.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )),
                currentAccountPicture: Container(
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
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/Screens/person.png",
                            );
                          },
                        )
                      : Image.asset(
                          "assets/images/Screens/person.png",
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _createDrawerItem(
                      context: context,
                      icon: Icons.person_2_outlined,
                      text: AppLocalizations.of(context)!.drawerMyProfile,
                      onTap: () {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: '/profile'),
                          withNavBar: false,
                          screen: const MyProfileScreen(),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                    ),
                    _createDrawerItem(
                      context: context,
                      icon: Icons.favorite_outline_outlined,
                      text: AppLocalizations.of(context)!.drawerLikedProducts,
                      onTap: () {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: '/MyFavourites'),
                          withNavBar: false,
                          screen: const FavoriteScreen(),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                    ),
                    _createDrawerItem(
                      context: context,
                      icon: Icons.notifications_none_outlined,
                      text: AppLocalizations.of(context)!.notification_settings,
                      onTap: () {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: '/notification'),
                          withNavBar: false,
                          screen: const NotificationSettingScreen(),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                    ),
                    _createDrawerItem(
                      context: context,
                      icon: Icons.tiktok,
                      text: AppLocalizations.of(context)!.tiktokSettings,
                      onTap: () {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings:
                              const RouteSettings(name: '/connect_with_tiktok'),
                          withNavBar: false,
                          screen: const ConnectWithTiktok(),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                    ),
                    _createDrawerItem(
                      context: context,
                      icon: Icons.security_outlined,
                      text: AppLocalizations.of(context)!.drawerSecurity,
                      onTap: () {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings:
                              const RouteSettings(name: '/reset_password'),
                          withNavBar: false,
                          screen: const PasswordResetScreen(),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                    ),
                    // _createDrawerItem(
                    //   context: context,
                    //   icon: Icons.help_outline,
                    //   text: AppLocalizations.of(context)!.drawerHelp,
                    //   onTap: () {},
                    // ),
                    // _createDrawerItem(
                    //   context: context,
                    //   icon: Icons.privacy_tip_outlined,
                    //   text: AppLocalizations.of(context)!.drawerPrivacyPolicy,
                    //   onTap: () {},
                    // ),
                    _createDrawerItem(
                      context: context,
                      icon: Icons.logout,
                      text: AppLocalizations.of(context)!.drawerLogout,
                      onTap: () async {
                        bool? confirmLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!
                                    .drawerConfirmLogoutTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                              content: Text(
                                AppLocalizations.of(context)!
                                    .drawerConfirmLogoutMessage,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.xxSmallSize),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.drawerCancel,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.xSmallSize,
                                      vertical: AppSize.xxSmallSize,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        AppSize.xxSmallSize,
                                      ),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .drawerLogout,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmLogout == true) {
                          () {
                            context.read<UserBloc>().add(SignOutEvent());
                            context
                                .read<UserBloc>()
                                .add(DisConnectFromTiktokEvent());

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const Auth(),
                              ),
                              (route) => false,
                            );
                          }();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                title: Text(
                  AppLocalizations.of(context)!.drawerDarkMode,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                value: Theme.of(context).brightness != Brightness.light,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(
                        ChangeThemeEvent(
                          themeMode: value ? ThemeMode.dark : ThemeMode.light,
                        ),
                      );
                },
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: AppSize.xSmallSize),
            child: SelectLanguage(),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      onTap: onTap,
    );
  }
}
