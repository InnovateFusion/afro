import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/shop/shop_entity.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_one.dart';
import '../widgets/common/custom_input_field_product.dart';

class UpdateShopSocialMedia extends StatefulWidget {
  const UpdateShopSocialMedia({
    super.key,
    required this.shop,
  });

  final ShopEntity shop;

  @override
  State<UpdateShopSocialMedia> createState() => _UpdateShopSocialMediaState();
}

class _UpdateShopSocialMediaState extends State<UpdateShopSocialMedia> {
  Map<String, String> selectedSocialMedia = {};
  Map<String, TextEditingController> controllers = {};

  Map<String, String> socialMediaLinksList = {
    'facebook': 'assets/icons/facebook.svg',
    'instagram': 'assets/icons/instagram.svg',
    'linkedin': 'assets/icons/linkedin.svg',
    'telegram': 'assets/icons/telegram.svg',
    'tiktok': 'assets/icons/tiktok.svg',
    'youtube': 'assets/icons/youtube.svg',
  };

  String capitalizeFirstOfEach(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  void initState() {
    super.initState();
    for (var socialMedia in socialMediaLinksList.keys) {
      controllers[socialMedia] = TextEditingController();
    }
    setState(() {
      for (var socialMedia in widget.shop.socialMediaLinks.keys) {
        controllers[socialMedia]!.text =
            widget.shop.socialMediaLinks[socialMedia]!;
        selectedSocialMedia[socialMedia] =
            widget.shop.socialMediaLinks[socialMedia]!;
      }
    });
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void onSaved() {
    if (socialMediaLinksList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.updateShopSocialMedia_addAtLeastOne,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }
    context.read<ShopBloc>().add(
          UpdateShopEvent(
            shopId: widget.shop.id,
            token: context.read<UserBloc>().state.user?.token ?? '',
            socialMedia: selectedSocialMedia,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            body: BlocListener<ShopBloc, ShopState>(
              listener: (context, state) {
                if (state.updateShopStatus == UpdateShopStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .updateShopSocialMedia_shopUpdatedSuccessfully,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                  Navigator.pop(context);
                } else if (state.updateShopStatus == UpdateShopStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          state.errorMessage,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  const AppBarOne(),
                  Divider(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    thickness: 2,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSize.smallSize),
                    child: Column(
                      children: socialMediaLinksList.keys
                          .map(
                            (socialMedia) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(AppSize.smallSize),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(
                                          AppSize.xSmallSize),
                                    ),
                                    child: SvgPicture.asset(
                                      socialMediaLinksList[socialMedia]!,
                                      height: 24.0,
                                      width: 24.0,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CustomInputFieldProduct(
                                      controller: controllers[socialMedia] ??
                                          TextEditingController(),
                                      hintText: AppLocalizations.of(context)!
                                          .updateShopSocialMedia_addSocialMediaLink(
                                              capitalizeFirstOfEach(
                                                  socialMedia)),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSocialMedia[socialMedia] =
                                              value;
                                        });
                                      },
                                      keyboardType: TextInputType.url,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )),
                  GestureDetector(
                    onTap: onSaved,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      margin: const EdgeInsets.all(AppSize.smallSize),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            BorderRadius.circular(AppSize.xxSmallSize),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .updateShopSocialMedia_updateSocialMedia,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (context.watch<ShopBloc>().state.updateShopStatus ==
              UpdateShopStatus.loading)
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
                              ? Theme.of(context).colorScheme.onPrimaryContainer
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
    );
  }
}
