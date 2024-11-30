import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../../../../core/utils/captilizations.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../pages/shop_detail.dart';
import '../../pages/update_shop_basic_info.dart';
import '../../pages/update_shop_social_media.dart';
import '../../pages/update_shop_working_hour.dart';

class AppBarThree extends StatefulWidget {
  const AppBarThree({
    super.key,
  });

  @override
  State<AppBarThree> createState() => _AppBarThreeState();
}

class _AppBarThreeState extends State<AppBarThree> {
  File? _logoImage;

  @override
  Widget build(BuildContext context) {
    Future<XFile?> cropImage(XFile pickedFile) async {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle:
                AppLocalizations.of(context)!.appBarThree_cropper, // Localize
            toolbarColor: Theme.of(context).colorScheme.secondary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title:
                AppLocalizations.of(context)!.appBarThree_cropper, // Localize
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      return croppedFile != null ? XFile(croppedFile.path) : null;
    }

    Future<void> pickImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final croppedFile = await cropImage(pickedFile);
        setState(() {
          if (croppedFile != null) {
            _logoImage = File(croppedFile.path);
          }
        });
      }
    }

    void showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!
                    .appBarThree_confirmDelete, // Localize
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w700)),
            content: Text(
                AppLocalizations.of(context)!
                    .appBarThree_deleteConfirmationMessage, // Localize
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                    AppLocalizations.of(context)!
                        .appBarThree_cancel, // Localize
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  context.read<ShopBloc>().add(
                        DeleteShopEvent(
                            id: context.read<ShopBloc>().state.myShopId ?? '',
                            token: context.read<UserBloc>().state.user!.token ??
                                ''),
                      );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.appBarThree_delete, // Localize
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSize.smallSize),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 32,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: AppSize.smallSize),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    width: 0.75,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    context
                        .watch<ShopBloc>()
                        .state
                        .shops[context.read<ShopBloc>().state.myShopId]!
                        .logo,
                  ) as ImageProvider,
                  radius: 22.5,
                ),
              ),
              const SizedBox(width: AppSize.smallSize),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Captilizations.capitalize(context
                        .watch<ShopBloc>()
                        .state
                        .shops[context.read<ShopBloc>().state.myShopId]!
                        .name
                        .substring(
                            0,
                            min(
                                context
                                    .watch<ShopBloc>()
                                    .state
                                    .shops[context
                                        .read<ShopBloc>()
                                        .state
                                        .myShopId]!
                                    .name
                                    .length,
                                15))),
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    context
                        .watch<ShopBloc>()
                        .state
                        .shops[context.read<ShopBloc>().state.myShopId]!
                        .subAdministrativeArea
                        .substring(
                            0,
                            min(
                              context
                                  .watch<ShopBloc>()
                                  .state
                                  .shops[
                                      context.read<ShopBloc>().state.myShopId]!
                                  .subAdministrativeArea
                                  .length,
                              20,
                            )),
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton<String>(
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            color: Theme.of(context).colorScheme.onPrimary,
            shadowColor: Theme.of(context).colorScheme.onPrimary,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () =>
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: const RouteSettings(name: '/shop/detail'),
                  withNavBar: false,
                  screen: ShopDetail(
                      shopId: context.read<ShopBloc>().state.myShopId ?? ''),
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                ),
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                        AppLocalizations.of(context)!
                            .appBarThree_viewPublicShop, // Localize
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  await pickImage();
                  if (_logoImage != null) {
                    context.read<ShopBloc>().add(
                          ShopImageUploadEvent(
                              image: _logoImage!,
                              token:
                                  context.read<UserBloc>().state.user!.token ??
                                      '',
                              isLogo: true),
                        );
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.image,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                        AppLocalizations.of(context)!
                            .appBarThree_changeShopLogo, // Localize
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  await pickImage();
                  if (_logoImage != null) {
                    context.read<ShopBloc>().add(
                          ShopImageUploadEvent(
                              image: _logoImage!,
                              token:
                                  context.read<UserBloc>().state.user!.token ??
                                      '',
                              isLogo: false),
                        );
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.photo,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                        AppLocalizations.of(context)!
                            .appBarThree_changeShopBanner, // Localize
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: '/shop/update'),
                    withNavBar: false,
                    screen: UpdateShopBasicInfo(
                      shop: context
                          .read<ShopBloc>()
                          .state
                          .shops[context.read<ShopBloc>().state.myShopId]!,
                    ),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.info,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                        AppLocalizations.of(context)!
                            .appBarThree_updateShopInfo, // Localize
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: '/shop/update'),
                    withNavBar: false,
                    screen: UpdateShopWorkingHour(
                      shop: context
                          .read<ShopBloc>()
                          .state
                          .shops[context.read<ShopBloc>().state.myShopId]!,
                    ),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                        AppLocalizations.of(context)!
                            .appBarThree_updateWorkHours, // Localize
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: '/shop/update'),
                    withNavBar: false,
                    screen: UpdateShopSocialMedia(
                      shop: context
                          .read<ShopBloc>()
                          .state
                          .shops[context.read<ShopBloc>().state.myShopId]!,
                    ),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.share,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                        AppLocalizations.of(context)!
                            .appBarThree_updateSocialMedia, // Localize
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  showDeleteConfirmationDialog(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: AppSize.xSmallSize),
                    Text(
                        AppLocalizations.of(context)!
                            .appBarThree_deleteShop, // Localize
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ],
                ),
              ),
            ],
            child: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
