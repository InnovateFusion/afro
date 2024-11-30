import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/CustomInputField.dart';
import 'success_screen.dart';

class ShopVerificationRequest extends StatefulWidget {
  const ShopVerificationRequest({super.key, required this.shopId});

  final String shopId;

  @override
  State<ShopVerificationRequest> createState() =>
      _ShopVerificationRequestState();
}

class _ShopVerificationRequestState extends State<ShopVerificationRequest>
    with SingleTickerProviderStateMixin {
  final TextEditingController licenseNumberController = TextEditingController();
  XFile? businessLicense;
  XFile? identityCard;
  XFile? yourPhoto;
  String? licenseNumberError;

  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> takePicture(int isBusinessLicense) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice:
          isBusinessLicense == 2 ? CameraDevice.front : CameraDevice.rear,
    );
    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile);
      if (croppedFile != null) {
        setState(() {
          if (isBusinessLicense == 0) {
            businessLicense = croppedFile;
          } else if (isBusinessLicense == 1) {
            identityCard = croppedFile;
          } else {
            yourPhoto = croppedFile;
          }
          _animationController.forward(from: 0); // Trigger animation
        });
      }
    }
  }

  void cancelImageSelection(int isBusinessLicense) {
    setState(() {
      if (isBusinessLicense == 0) {
        businessLicense = null;
      } else if (isBusinessLicense == 1) {
        identityCard = null;
      } else {
        yourPhoto = null;
      }
    });
  }

  Future<XFile?> _cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.cropperToolbarTitle,
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: Theme.of(context).colorScheme.onPrimaryContainer,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: AppLocalizations.of(context)!.cropperToolbarTitle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );
    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

  bool isFormValid() {
    return licenseNumberController.text.isNotEmpty &&
        businessLicense != null &&
        identityCard != null &&
        yourPhoto != null;
  }

  Future<String> getBase64ImageFromFile(XFile image) async {
    final File imageFile = File(image.path);
    if (!imageFile.existsSync()) {
      return '';
    }
    List<int> imageBytes = await imageFile.readAsBytes();
    return "data:image/png;base64,${base64Encode(imageBytes)}";
  }

  void linkBusinessLicense(String value) {
    setState(() {
      licenseNumberError = value.isEmpty
          ? AppLocalizations.of(context)!.pleaseEnterLicenseNumber
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    Widget builderDetails(String title, Widget value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: AppSize.xSmallSize),
          value,
        ],
      );
    }

    Widget buildImageContainer({
      required XFile? imageFile,
      required VoidCallback onAdd,
      required VoidCallback onCancel,
      String? tooltip,
    }) {
      return GestureDetector(
        onTap: onAdd,
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: imageFile == null
                ? LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ])
                : null,
            image: imageFile != null
                ? DecorationImage(
                    image: FileImage(File(imageFile.path)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Stack(
            children: [
              if (imageFile == null)
                Center(
                  child: Icon(
                    Icons.add_a_photo,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 40,
                  ),
                ),
              if (imageFile != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Tooltip(
                    message: tooltip ?? localizations.cancel,
                    child: IconButton(
                      icon: const Icon(Icons.cancel_rounded),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: onCancel,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: BlocListener<ShopBloc, ShopState>(
        listener: (context, state) {
          if (state.requestShopVerificationStatus ==
              RequestShopVerificationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
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
                            localizations.shopVerificationRequest,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                    const SizedBox(height: AppSize.smallSize),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.smallSize),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          builderDetails(
                            localizations.businessLicenseNumber,
                            CustomInputField(
                              controller: licenseNumberController,
                              hintText: localizations.enterShopLicenseNumber,
                              errorText: licenseNumberError,
                              onChanged: linkBusinessLicense,
                            ),
                          ),
                          const SizedBox(height: AppSize.mediumSize),
                          builderDetails(
                            localizations.businessLicense,
                            buildImageContainer(
                              imageFile: businessLicense,
                              onAdd: () => takePicture(0),
                              onCancel: () => cancelImageSelection(0),
                              tooltip: localizations.removeBusinessLicenseImage,
                            ),
                          ),
                          const SizedBox(height: AppSize.mediumSize),
                          builderDetails(
                            localizations.yourPhoto,
                            buildImageContainer(
                              imageFile: yourPhoto,
                              onAdd: () => takePicture(2),
                              onCancel: () => cancelImageSelection(2),
                              tooltip: localizations.removeYourSelfie,
                            ),
                          ),
                          const SizedBox(height: AppSize.mediumSize),
                          builderDetails(
                            localizations.identityCardOrPassport,
                            buildImageContainer(
                              imageFile: identityCard,
                              onAdd: () => takePicture(1),
                              onCancel: () => cancelImageSelection(1),
                              tooltip: localizations.removeIdentityCardImage,
                            ),
                          ),
                          const SizedBox(height: AppSize.mediumSize),
                          GestureDetector(
                            onTap: () async {
                              if (isFormValid()) {
                                context.read<ShopBloc>().add(
                                      RequestShopVerificationEvent(
                                        id: widget.shopId,
                                        token: context
                                                .read<UserBloc>()
                                                .state
                                                .user
                                                ?.token ??
                                            "",
                                        businessRegistrationNumber:
                                            licenseNumberController.text,
                                        businessRegistrationDocumentUrl:
                                            await getBase64ImageFromFile(
                                                businessLicense!),
                                        ownerIdentityCardUrl:
                                            await getBase64ImageFromFile(
                                                identityCard!),
                                        ownerSelfieUrl:
                                            await getBase64ImageFromFile(
                                                yourPhoto!),
                                      ),
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        licenseNumberController.text.isEmpty
                                            ? AppLocalizations.of(context)!
                                                .pleaseEnterLicenseNumber
                                            : businessLicense == null
                                                ? AppLocalizations.of(context)!
                                                    .pleaseAddBusinessLicense
                                                : identityCard == null
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .pleaseAddIdentityCard
                                                    : yourPhoto == null
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .pleaseAddYourSelfie
                                                        : AppLocalizations.of(
                                                                context)!
                                                            .pleaseFillAllFields,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                      ),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                );
                              }
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
                                localizations.verify,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSize.smallSize),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (context
                      .watch<ShopBloc>()
                      .state
                      .requestShopVerificationStatus ==
                  RequestShopVerificationStatus.loading)
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
              if (context
                      .watch<ShopBloc>()
                      .state
                      .requestShopVerificationStatus ==
                  RequestShopVerificationStatus.success)
                const SuccessScreen()
            ],
          ),
        ),
      ),
    );
  }
}
