import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/utils/captilizations.dart';
import '../../domain/entities/product/product_entity.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/user/user_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../setUp/size/app_size.dart';
import '../../../../setUp/url/urls.dart';
import '../widgets/common/show_image.dart';

class UploadToTiktok extends StatefulWidget {
  const UploadToTiktok({super.key, required this.product});

  final ProductEntity product;

  @override
  State<UploadToTiktok> createState() => _UploadToTiktokState();
}

class _UploadToTiktokState extends State<UploadToTiktok> {
  bool isComment = true;
  bool isDuet = true;
  bool isStitch = true;
  bool isYourBrand = false;
  bool isBrandedContent = false;
  bool isDisclose = false;
  bool isAutoAddMusic = true;
  int selectedPhotoIndex = 0;
  String? nameError;
  String? descriptionError;
  String visibility = 'Public';
  int postType = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure this only runs once by checking if the text is already set
    if (nameController.text.isEmpty && descriptionController.text.isEmpty) {
      nameController.text =
          Captilizations.capitalizeFirstOfEach(widget.product.title);

      String delimiter = " | ";

      String price =
          "${AppLocalizations.of(context)!.price_tiktok}${widget.product.price} ETB$delimiter";
      String phone =
          "${AppLocalizations.of(context)!.phone_tiktok}${widget.product.shopInfo.phoneNumber}$delimiter";
      String location =
          "${AppLocalizations.of(context)!.location_tiktok}${Captilizations.capitalize(widget.product.shopInfo.subAdministrativeArea)} - ${Captilizations.capitalize(widget.product.shopInfo.subLocality)}";

      descriptionController.text = price + phone + location;
    }
  }

  void validateName(String value) {
    if (value.isEmpty) {
      setState(() {
        nameError = AppLocalizations.of(context)!.caption_required;
      });
    } else if (value.length > 100) {
      setState(() {
        nameError = AppLocalizations.of(context)!.caption_length;
      });
    } else {
      setState(() {
        nameError = null;
      });
    }
  }

  void validateDescription(String value) {
    if (value.isEmpty) {
      setState(() {
        descriptionError = AppLocalizations.of(context)!.description_required;
      });
    } else if (value.length > 250) {
      setState(() {
        descriptionError = AppLocalizations.of(context)!.description_length;
      });
    } else {
      setState(() {
        descriptionError = null;
      });
    }
  }

  String mapVisibility(String value) {
    switch (value) {
      case 'Public':
        return 'PUBLIC_TO_EVERYONE';
      case 'Private':
        return 'SELF_ONLY';
      case 'Friends':
        return 'FOLLOWER_OF_CREATOR';
      default:
        return 'PUBLIC_TO_EVERYONE';
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Widget builderDetails(String title, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        value,
      ],
    );
  }

  Widget builderDetailsWithTag(String title, Widget value, Widget tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            tag,
          ],
        ),
        value,
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String mapVisibilityList(String value) {
    switch (value) {
      case 'Public':
        return AppLocalizations.of(context)!.visibility_public;
      case 'Private':
        return AppLocalizations.of(context)!.visibility_private;
      default:
        return AppLocalizations.of(context)!.visibility_friends;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) async {
              if (state.shareProductToTiktokStatus ==
                  ShareProductToTiktokStatus.success) {
                final deeplink =
                    context.read<UserBloc>().state.tiktoker!.profileDeepLink;

                if (await canLaunchUrl(Uri.parse(deeplink))) {
                  await launchUrl(Uri.parse(deeplink));
                }
              } else if (state.shareProductToTiktokStatus ==
                  ShareProductToTiktokStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        'Failed to share product to TikTok',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: AppSize.smallSize),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius:
                                    BorderRadius.circular(AppSize.xxxLargeSize),
                              ),
                              child: ShowImage(
                                  image: context
                                          .watch<UserBloc>()
                                          .state
                                          .tiktoker
                                          ?.avatarUrl ??
                                      Urls.dummyImage),
                            ),
                            const SizedBox(width: AppSize.smallSize),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Captilizations.capitalizeFirstOfEach(context
                                          .watch<UserBloc>()
                                          .state
                                          .tiktoker
                                          ?.displayName ??
                                      ''),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 18,
                                        height: 1,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                Text(
                                  context
                                          .watch<UserBloc>()
                                          .state
                                          .tiktoker
                                          ?.username ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        height: 1.2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSize.smallSize),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSize.xSmallSize),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Container(
                          //       padding: const EdgeInsets.all(
                          //         AppSize.xSmallSize,
                          //       ),
                          //       decoration: BoxDecoration(
                          //         color: Theme.of(context)
                          //             .colorScheme
                          //             .primaryContainer,
                          //         borderRadius:
                          //             BorderRadius.circular(AppSize.largeSize),
                          //       ),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 postType = 0;
                          //               });
                          //             },
                          //             child: Container(
                          //               padding: const EdgeInsets.symmetric(
                          //                   horizontal: AppSize.smallSize,
                          //                   vertical: AppSize.xSmallSize),
                          //               decoration: BoxDecoration(
                          //                 color: postType == 0
                          //                     ? Theme.of(context)
                          //                         .colorScheme
                          //                         .primary
                          //                     : Theme.of(context)
                          //                         .colorScheme
                          //                         .primaryContainer,
                          //                 borderRadius: BorderRadius.circular(
                          //                     AppSize.mediumSize),
                          //               ),
                          //               child: Text(
                          //                 "Direct Post",
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .titleMedium!
                          //                     .copyWith(
                          //                         color: postType == 0
                          //                             ? Theme.of(context)
                          //                                 .colorScheme
                          //                                 .onPrimaryContainer
                          //                             : Theme.of(context)
                          //                                 .colorScheme
                          //                                 .onSurface),
                          //               ),
                          //             ),
                          //           ),
                          //           const SizedBox(width: AppSize.smallSize),
                          //           GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 postType = 1;
                          //               });
                          //             },
                          //             child: Container(
                          //               padding: const EdgeInsets.symmetric(
                          //                   horizontal: AppSize.smallSize,
                          //                   vertical: AppSize.xSmallSize),
                          //               decoration: BoxDecoration(
                          //                 color: postType == 1
                          //                     ? Theme.of(context)
                          //                         .colorScheme
                          //                         .primary
                          //                     : Theme.of(context)
                          //                         .colorScheme
                          //                         .primaryContainer,
                          //                 borderRadius: BorderRadius.circular(
                          //                     AppSize.mediumSize),
                          //               ),
                          //               child: Text(
                          //                 "Draft Upload",
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .titleMedium!
                          //                     .copyWith(
                          //                         color: postType == 1
                          //                             ? Theme.of(context)
                          //                                 .colorScheme
                          //                                 .onPrimaryContainer
                          //                             : Theme.of(context)
                          //                                 .colorScheme
                          //                                 .onSurface),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          const SizedBox(height: AppSize.xSmallSize),
                          builderDetails(
                            AppLocalizations.of(context)!.caption,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: AppSize.xSmallSize),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(
                                        AppSize.smallSize),
                                  ),
                                  child: TextFormField(
                                    controller: nameController,
                                    onChanged: validateName,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .write_caption,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                if (nameError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppSize.xSmallSize),
                                    child: Text(
                                      nameError!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSize.mediumSize),
                          builderDetails(
                            AppLocalizations.of(context)!.description,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: AppSize.xSmallSize),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(
                                        AppSize.smallSize),
                                  ),
                                  child: TextFormField(
                                    controller: descriptionController,
                                    onChanged: validateDescription,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .write_description,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                if (nameError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppSize.xSmallSize),
                                    child: Text(
                                      descriptionError!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSize.mediumSize),
                          builderDetails(
                            AppLocalizations.of(context)!.select_cover_photo,
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: AppSize.xSmallSize),
                              child: Wrap(
                                spacing: AppSize.smallSize,
                                runSpacing: AppSize.smallSize,
                                children: [
                                  for (int i = 0;
                                      i < widget.product.images.length;
                                      i++)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedPhotoIndex = i;
                                        });
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                              AppSize.xSmallSize),
                                          border: Border.all(
                                            color: selectedPhotoIndex == i
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                    .withOpacity(0.6)
                                                : Colors.transparent,
                                            width: 4.0,
                                          ),
                                        ),
                                        child: ShowImage(
                                          image:
                                              widget.product.images[i].imageUri,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (postType == 0)
                            const SizedBox(height: AppSize.mediumSize),
                          if (postType == 0)
                            builderDetails(
                              AppLocalizations.of(context)!.who_can_view,
                              Container(
                                margin: const EdgeInsets.only(
                                    top: AppSize.xSmallSize),
                                padding: const EdgeInsets.only(
                                  bottom: AppSize.xSmallSize,
                                  left: AppSize.smallSize,
                                  right: AppSize.smallSize,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.xSmallSize),
                                ),
                                child: DropdownButton<String>(
                                  value: visibility,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                  underline: Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  dropdownColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      visibility = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Public',
                                    'Private',
                                    'Friends'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        mapVisibilityList(value),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          if (postType == 0)
                            const SizedBox(height: AppSize.mediumSize),
                          if (postType == 0)
                            builderDetails(
                              AppLocalizations.of(context)!.allow_users_to,
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isComment,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isComment = value!;
                                          });
                                        },
                                        checkColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.comment,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: AppSize.mediumSize),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isAutoAddMusic,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isAutoAddMusic = value!;
                                          });
                                        },
                                        checkColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .auto_add_music,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          if (postType == 0)
                            const SizedBox(height: AppSize.smallSize),
                          if (postType == 0)
                            builderDetailsWithTag(
                              AppLocalizations.of(context)!.disclose_content,
                              Column(
                                children: [
                                  if (isDisclose)
                                    Container(
                                      padding: const EdgeInsets.all(
                                          AppSize.xSmallSize),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: BorderRadius.circular(
                                            AppSize.xSmallSize),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          const SizedBox(
                                              width: AppSize.smallSize),
                                          Flexible(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .disclose_content,
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    height: 1.2,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (isDisclose)
                                    const SizedBox(height: AppSize.smallSize),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .disclose_instruction,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: isDisclose,
                                onChanged: (bool value) {
                                  setState(() {
                                    isDisclose = value;
                                  });
                                },
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          if (postType == 0)
                            const SizedBox(height: AppSize.smallSize),
                          if (postType == 0)
                            builderDetailsWithTag(
                              AppLocalizations.of(context)!.your_brand,
                              Text(
                                AppLocalizations.of(context)!.your_brand_info,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Checkbox(
                                value: isYourBrand,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isYourBrand = value!;
                                  });
                                },
                                checkColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          if (postType == 0)
                            const SizedBox(height: AppSize.smallSize),
                          if (postType == 0)
                            builderDetailsWithTag(
                              AppLocalizations.of(context)!.branded_content,
                              Text(
                                AppLocalizations.of(context)!
                                    .branded_content_info,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Checkbox(
                                value: isBrandedContent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isBrandedContent = value!;
                                  });
                                },
                                checkColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          const SizedBox(height: AppSize.largeSize),
                          GestureDetector(
                            onTap: () {
                              context.read<ProductBloc>().add(
                                    ShareProductToTiktokEvent(
                                      accessToken: context
                                              .read<UserBloc>()
                                              .state
                                              .user
                                              ?.tikTokAccessToken ??
                                          '',
                                      title: nameController.text.trim(),
                                      description:
                                          descriptionController.text.trim(),
                                      disableComments: !isComment,
                                      duetDisabled: !isDuet,
                                      stitchDisabled: !isStitch,
                                      privcayLevel: mapVisibility(visibility),
                                      autoAddMusic: isAutoAddMusic,
                                      source: 'PULL_FROM_URL',
                                      photoCoverIndex: selectedPhotoIndex,
                                      photoImages: widget.product.images
                                          .map((e) => e.imageUri)
                                          .toList(),
                                      postMode: postType == 0
                                          ? "DIRECT_POST"
                                          : "MEDIA_UPLOAD",
                                      mediaType: "PHOTO",
                                      brandContentToggle: isBrandedContent,
                                      brandOrganicToggle: isYourBrand,
                                    ),
                                  );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSize.smallSize),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius:
                                    BorderRadius.circular(AppSize.xSmallSize),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.upload_to_tiktok,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (context.watch<ProductBloc>().state.shareProductToTiktokStatus ==
              ShareProductToTiktokStatus.loading)
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
