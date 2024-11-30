import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/user/notification_setting_entity.dart';
import '../bloc/user/user_bloc.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  @override
  void initState() {
    super.initState();
    notificationSettings = [
      context.read<UserBloc>().state.user?.notificationSettings?.message ??
          true,
      context.read<UserBloc>().state.user?.notificationSettings?.review ?? true,
      context.read<UserBloc>().state.user?.notificationSettings?.follow ?? true,
      context.read<UserBloc>().state.user?.notificationSettings?.favorite ??
          true,
      context.read<UserBloc>().state.user?.notificationSettings?.verify ?? true,
    ];
  }

  List<bool> notificationSettings = [];

  void onSaved() {
    context.read<UserBloc>().add(
          UpdateProfileEvent(
              notificationSetting: NotificationSettingEntity(
            message: notificationSettings[0],
            review: notificationSettings[1],
            follow: notificationSettings[2],
            favorite: notificationSettings[3],
            verify: notificationSettings[4],
          )),
        );
  }

  @override
  Widget build(BuildContext context) {
    List<String> notificationSettingsName = [
      AppLocalizations.of(context)!.notification_chat,
      AppLocalizations.of(context)!.notification_shop_review,
      AppLocalizations.of(context)!.notification_shop,
      AppLocalizations.of(context)!.notification_favorite,
      AppLocalizations.of(context)!.notification_verification,
    ];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                          AppLocalizations.of(context)!.notification_settings,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(width: AppSize.xLargeSize),
                      ],
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    thickness: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSize.smallSize),
                      child: Column(
                        children: [
                          for (var item in notificationSettingsName)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                Switch(
                                  value: notificationSettings[
                                      notificationSettingsName.indexOf(item)],
                                  onChanged: (value) {
                                    setState(() {
                                      notificationSettings[
                                          notificationSettingsName
                                              .indexOf(item)] = value;
                                    });
                                  },
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onSaved,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(AppSize.smallSize),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.smallSize,
                          vertical: AppSize.smallSize),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.notification_save,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (context.watch<UserBloc>().state.myProfileStatus ==
                MyProfileStatus.loading)
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
      ),
    );
  }
}
