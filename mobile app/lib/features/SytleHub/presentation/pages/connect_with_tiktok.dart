import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Localization import
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../setUp/service/local_cache.dart';
import '../../../../setUp/size/app_size.dart';
import '../bloc/user/user_bloc.dart';

class ConnectWithTiktok extends StatefulWidget {
  const ConnectWithTiktok({super.key});

  static const platform = MethodChannel("com.example.afro_stores/auth");

  @override
  State<ConnectWithTiktok> createState() => _ConnectWithTiktokState();
}

class _ConnectWithTiktokState extends State<ConnectWithTiktok> {
  @override
  void initState() {
    super.initState();
    if (context.read<UserBloc>().state.tiktoker == null) {
      context.read<UserBloc>().add(GetTiktokerInfoEvent());
    }
  }

  void onClick() async {
    try {
      await LocalCache.saveString("currentChannel", "connectWithTiktok");
      await ConnectWithTiktok.platform.invokeMethod('connectWithTiktok');
    } on PlatformException {
      () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!
                  .tiktokSignInSomethingWentWrong, // Localized error message
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Access localization

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Stack(
        children: [
          SafeArea(
            child: context
                        .watch<UserBloc>()
                        .state
                        .getTiktokerProfileDetailStatus ==
                    GetTiktokerProfileDetailStatus.success
                ? _buildTiktokProfile(context, localizations)
                : _buildLoadingScreen(context),
          ),
          if (context.watch<UserBloc>().state.getTiktokerProfileDetailStatus ==
                  GetTiktokerProfileDetailStatus.loading ||
              context.watch<UserBloc>().state.connectToTiktokStatus ==
                  ConnectToTiktokStatus.loading ||
              context.watch<UserBloc>().state.loginWithTiktokStatus ==
                  LoginWithTiktokStatus.loading)
            _buildLoadingOverlay(context),
        ],
      ),
    );
  }

  Widget _buildTiktokProfile(
      BuildContext context, AppLocalizations localizations) {
    final tiktoker = context.watch<UserBloc>().state.tiktoker!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.smallSize),
      child: Column(
        children: [
          _buildBackButton(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(tiktoker.avatarUrl),
                ),
                const SizedBox(height: AppSize.xxSmallSize),
                Text(
                  tiktoker.displayName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Text(
                  '@${tiktoker.username}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: AppSize.mediumSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    userProfileDetails(context, localizations.tiktokFollowers,
                        tiktoker.followerCount.toString()),
                    userProfileDetails(context, localizations.tiktokFollowing,
                        tiktoker.followingCount.toString()),
                    userProfileDetails(context, localizations.tiktokLikes,
                        tiktoker.likesCount.toString()),
                  ],
                ),
                const SizedBox(height: AppSize.mediumSize),
                _buildProfileLinkButton(context, localizations),
                const SizedBox(height: AppSize.smallSize),
                _buildDisconnectButton(context, localizations),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSize.smallSize),
      child: Column(
        children: [
          _buildBackButton(context),
          Expanded(child: CoolTikTokScreen(onClick: onClick)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.scrim.withOpacity(0.95),
      child: Center(
        child: SpinKitCircle(
          size: 200,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(AppSize.smallSize - 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSize.smallSize),
            ),
            child: Icon(
              Icons.arrow_back_outlined,
              size: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileLinkButton(
      BuildContext context, AppLocalizations localizations) {
    final deeplink = context.read<UserBloc>().state.tiktoker!.profileDeepLink;

    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(deeplink))) {
          await launchUrl(Uri.parse(deeplink));
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
        padding: const EdgeInsets.all(AppSize.smallSize),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(AppSize.xSmallSize),
        ),
        child: Text(
          localizations.tiktokGoToTiktok,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDisconnectButton(
      BuildContext context, AppLocalizations localizations) {
    return GestureDetector(
      onTap: () {
        context.read<UserBloc>().add(DisConnectFromTiktokEvent());
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
        padding: const EdgeInsets.all(AppSize.smallSize),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSize.xSmallSize),
        ),
        child: Text(
          localizations.tiktokDisconnectTiktok,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Column userProfileDetails(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }
}

class CoolTikTokScreen extends StatefulWidget {
  const CoolTikTokScreen({super.key, required this.onClick});

  final VoidCallback onClick;

  @override
  State<CoolTikTokScreen> createState() => _CoolTikTokScreenState();
}

class _CoolTikTokScreenState extends State<CoolTikTokScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: math.sin(_controller.value * math.pi) * (math.pi / 6),
              child: SvgPicture.asset(
                'assets/icons/tiktok.svg',
                width: 280,
                height: 280,
              ),
            );
          },
        ),
        const SizedBox(height: AppSize.xxLargeSize),
        GestureDetector(
          onTap: widget.onClick,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
            padding: const EdgeInsets.all(AppSize.smallSize),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              AppLocalizations.of(context)!.tiktokGoToTiktok,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
