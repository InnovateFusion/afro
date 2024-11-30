import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:permission_handler/permission_handler.dart' as my_permission;
import 'package:permission_handler/permission_handler.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/custom_input_field_product.dart';
import 'location_picker.dart';

class CreateShop extends StatefulWidget {
  const CreateShop({super.key});

  @override
  State<CreateShop> createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShop> {
  int currentPage = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  Map<String, String> selectedSocialMedia = {};
  bool isPickUplocation = false;

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final List<String> times = [
    "morning",
    "afternoon",
    "evening",
    "all_day",
    "close"
  ];
  Map<String, String> selectedWorkingHours = {};

  String? nameError;
  String? descriptionError;
  File? _logoImage;
  String? phoneError;
  String? websiteError;
  Address? _currentAddress;
  Position? _currentPosition;
  List<String> selectedCategories = [];
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void validateName(String value) {
    if (value.isEmpty) {
      setState(() {
        nameError =
            AppLocalizations.of(context)!.updateShopBasicInfo_nameRequired;
      });
    } else if (value.length < 3) {
      setState(() {
        nameError =
            AppLocalizations.of(context)!.updateShopBasicInfo_nameMinLength;
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
        descriptionError = AppLocalizations.of(context)!
            .updateShopBasicInfo_descriptionRequired;
      });
    } else if (value.length < 20) {
      setState(() {
        descriptionError = AppLocalizations.of(context)!
            .updateShopBasicInfo_descriptionMinLength;
      });
    } else {
      setState(() {
        descriptionError = null;
      });
    }
  }

  Future<void> pickLogoImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile);
      setState(() {
        if (croppedFile != null) {
          _logoImage = File(croppedFile.path);
        }
      });
    }
  }

  Future<XFile?> _cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );

    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

  void validatePhone(String value) {
    if (value.isEmpty) {
      setState(() {
        phoneError =
            AppLocalizations.of(context)!.updateShopBasicInfo_phoneRequired;
      });
    } else if (value.length < 10 || value.length > 15) {
      setState(() {
        phoneError =
            AppLocalizations.of(context)!.updateShopBasicInfo_phoneInvalid;
      });
    } else {
      setState(() {
        phoneError = null;
      });
    }
  }

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
        const SizedBox(height: AppSize.xSmallSize),
        value,
      ],
    );
  }

  Widget buildImageContainer({
    required File? imageFile,
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
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
                  size: 50,
                ),
              ),
            if (imageFile != null)
              Positioned(
                right: 0,
                top: 0,
                child: Tooltip(
                  message: tooltip ?? 'Cancel',
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

  bool validateShopDetails() {
    validateName(nameController.text);
    validateDescription(descriptionController.text);
    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.shop_select_category,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
    if (_logoImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.shop_select_logo,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    return nameError == null &&
        descriptionError == null &&
        selectedCategories.isNotEmpty &&
        _logoImage != null;
  }

  bool validateShopContact() {
    validatePhone(phoneController.text);
    if (_currentAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.shop_select_pickup_address,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    return phoneError == null && _currentAddress != null;
  }

  bool validateShopWorkingHour() {
    if (selectedWorkingHours.length != 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.shop_select_working_hours_per_day,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return false;
    }
    return true;
  }

  void onSubmit() {
    context.read<ShopBloc>().add(
          CreateShopEvent(
              name: nameController.text,
              description: descriptionController.text,
              categories: selectedCategories,
              logo: _logoImage!,
              phone: phoneController.text,
              website: websiteController.text.isEmpty
                  ? null
                  : websiteController.text,
              address: _currentAddress!,
              latitude: _currentPosition!.latitude,
              longitude: _currentPosition!.longitude,
              socialMedia: selectedSocialMedia,
              workingHours: selectedWorkingHours,
              token: context.read<UserBloc>().state.user?.token ?? ''),
        );
  }

  String capitalizeFirstOfEach(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    List<String> stepperPageNames = [
      AppLocalizations.of(context)!.shop_details,
      AppLocalizations.of(context)!.shop_contacts,
      AppLocalizations.of(context)!.shop_social_media,
      AppLocalizations.of(context)!.shop_working_hour
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: BlocListener<ShopBloc, ShopState>(
          listener: (context, state) {
            if (state.createShopStatus == CreateShopStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      AppLocalizations.of(context)!.shop_created_successfully,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
              Navigator.pop(context);
            }

            if (state.createShopStatus == CreateShopStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      state.errorMessage,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppSize.smallSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding:
                                const EdgeInsets.all(AppSize.smallSize - 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius:
                                  BorderRadius.circular(AppSize.smallSize),
                            ),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 28,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Current page info
                    const SizedBox(height: AppSize.mediumSize),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.shop_create_your_shop,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          stepperPageNames[currentPage],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    // Step indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage >= index
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                ),
                                child: Center(
                                    child: currentPage > index
                                        ? Icon(
                                            Icons.check,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                            size: 20,
                                          )
                                        : currentPage == index
                                            ? Icon(
                                                Icons.circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: 20,
                                              )),
                              ),
                              if (index < 2)
                                Container(
                                  width: 40,
                                  height: 2,
                                  color: currentPage > index
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    // Page content
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: currentPage == 0
                          ? shopDetail(context)
                          : currentPage == 1
                              ? shopContact(context)
                              : shopWorkingHour(context),
                    ),
                    const SizedBox(height: AppSize.largeSize),

                    Row(
                      mainAxisAlignment: currentPage == 0
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentPage > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentPage--;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.xSmallSize),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.shop_previous,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            if (currentPage == 0) {
                              if (validateShopDetails()) {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            } else if (currentPage == 1) {
                              if (validateShopContact()) {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            } else if (currentPage == 2) {
                              if (validateShopWorkingHour()) {
                                onSubmit();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSize.xSmallSize),
                            ),
                          ),
                          child: Text(
                            currentPage < 2
                                ? AppLocalizations.of(context)!.shop_next
                                : AppLocalizations.of(context)!.shop_submit,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (context.watch<ShopBloc>().state.createShopStatus ==
                  CreateShopStatus.loading)
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
      ),
    );
  }

  Column shopDetail(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        builderDetails(
          AppLocalizations.of(context)!.updateShopBasicInfo_name,
          CustomInputFieldProduct(
            controller: nameController,
            hintText: AppLocalizations.of(context)!.updateShopBasicInfo_name,
            errorText: nameError,
            onChanged: validateName,
          ),
        ),
        const SizedBox(height: AppSize.smallSize),
        builderDetails(
          AppLocalizations.of(context)!.updateShopBasicInfo_description,
          CustomInputFieldProduct(
            controller: descriptionController,
            hintText:
                AppLocalizations.of(context)!.updateShopBasicInfo_description,
            errorText: descriptionError,
            onChanged: validateDescription,
            maxLines: 5,
          ),
        ),
        const SizedBox(height: AppSize.smallSize),
        builderDetails(
          AppLocalizations.of(context)!.updateShopBasicInfo_selectCategory,
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: AppSize.xSmallSize),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.xSmallSize),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: MultiSelectDialogField(
              items: [
                MultiSelectItem(
                  "men's fashion",
                  AppLocalizations.of(context)!.updateShopBasicInfo_mensFashion,
                ),
                MultiSelectItem(
                  "women's fashion",
                  AppLocalizations.of(context)!
                      .updateShopBasicInfo_womensFashion,
                ),
                MultiSelectItem(
                  "kids fashion",
                  AppLocalizations.of(context)!.updateShopBasicInfo_kidsFashion,
                ),
                MultiSelectItem(
                  "health & beauty",
                  AppLocalizations.of(context)!
                      .updateShopBasicInfo_healthAndBeauty,
                ),
                MultiSelectItem(
                  "sports & outdoors",
                  AppLocalizations.of(context)!
                      .updateShopBasicInfo_sportsAndOutdoors,
                ),
                MultiSelectItem(
                  "other",
                  AppLocalizations.of(context)!.updateShopBasicInfo_other,
                ),
              ],
              title: Text(
                AppLocalizations.of(context)!
                    .updateShopBasicInfo_selectCategory,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              selectedColor: Theme.of(context).colorScheme.secondary,
              selectedItemsTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppSize.xSmallSize),
                ),
              ),
              buttonText: Text(
                AppLocalizations.of(context)!
                    .updateShopBasicInfo_selectCategory,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              initialValue: selectedCategories,
              onConfirm: (values) {
                setState(() {
                  selectedCategories = values;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: AppSize.smallSize),
        builderDetails(
          AppLocalizations.of(context)!.shop_logo,
          buildImageContainer(
              imageFile: _logoImage,
              onAdd: pickLogoImage,
              onCancel: () {
                setState(() {
                  _logoImage = null;
                });
              }),
        ),
      ],
    );
  }

  Widget shopContact(BuildContext context) {
    return Column(children: [
      builderDetails(
        AppLocalizations.of(context)!.updateShopBasicInfo_phone,
        CustomInputFieldProduct(
          controller: phoneController,
          hintText: AppLocalizations.of(context)!.updateShopBasicInfo_phone,
          errorText: phoneError,
          onChanged: validatePhone,
          keyboardType: TextInputType.phone,
        ),
      ),
      const SizedBox(height: AppSize.smallSize),
      builderDetails(
        AppLocalizations.of(context)!.updateShopBasicInfo_websiteOptional,
        CustomInputFieldProduct(
          controller: websiteController,
          hintText:
              AppLocalizations.of(context)!.updateShopBasicInfo_websiteOptional,
          errorText: websiteError,
          keyboardType: TextInputType.url,
        ),
      ),
      const SizedBox(height: AppSize.smallSize),
      builderDetails(
        AppLocalizations.of(context)!.updateShopBasicInfo_pickupAddress,
        GestureDetector(
          onTap: () async {
            my_permission.PermissionStatus status =
                await my_permission.Permission.location.request();

            if (status == my_permission.PermissionStatus.granted) {
              setState(() {
                isPickUplocation = true;
              });
              try {
                _currentPosition = await LocationHandler.getCurrentPosition();
                if (_currentPosition == null) {
                } else {
                  _currentAddress = await LocationHandler.getAddressFromLatLng(
                      _currentPosition!);
                }
              } catch (e) {
                await openAppSettings();
              }
              setState(() {
                isPickUplocation = false;
              });
            } else if (status == my_permission.PermissionStatus.denied) {
              await my_permission.Permission.location.request();
            } else if (status ==
                my_permission.PermissionStatus.permanentlyDenied) {
              await openAppSettings();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.smallSize, vertical: AppSize.xSmallSize),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSize.xSmallSize),
            ),
            height: 60,
            child: isPickUplocation
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    children: [
                      Text(
                        _currentAddress?.subAdministrativeArea != null
                            ? '${_currentAddress?.subAdministrativeArea}, ${_currentAddress?.subLocality}'
                            : AppLocalizations.of(context)!
                                .shop_select_pickup_address,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ]);
  }

  Widget shopWorkingHour(BuildContext context) {
    String getLocalizedDay(String day) {
      switch (day) {
        case "monday":
          return AppLocalizations.of(context)!.updateShopWorkingHour_monday;
        case "tuesday":
          return AppLocalizations.of(context)!.updateShopWorkingHour_tuesday;
        case "wednesday":
          return AppLocalizations.of(context)!.updateShopWorkingHour_wednesday;
        case "thursday":
          return AppLocalizations.of(context)!.updateShopWorkingHour_thursday;
        case "friday":
          return AppLocalizations.of(context)!.updateShopWorkingHour_friday;
        case "saturday":
          return AppLocalizations.of(context)!.updateShopWorkingHour_saturday;
        case "sunday":
          return AppLocalizations.of(context)!.updateShopWorkingHour_sunday;
        default:
          return day;
      }
    }

    String getLocalizedTime(String time) {
      switch (time) {
        case "morning":
          return AppLocalizations.of(context)!.updateShopWorkingHour_morning;
        case "afternoon":
          return AppLocalizations.of(context)!.updateShopWorkingHour_afternoon;
        case "evening":
          return AppLocalizations.of(context)!.updateShopWorkingHour_evening;
        case "all_day":
          return AppLocalizations.of(context)!.updateShopWorkingHour_all_day;
        case "close":
          return AppLocalizations.of(context)!.updateShopWorkingHour_close;
        default:
          return time;
      }
    }

    return Column(
      children: days
          .map(
            (day) => Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.xSmallSize),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        getLocalizedDay(day.toLowerCase()),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: selectedWorkingHours[day],
                      hint: Text(
                        AppLocalizations.of(context)!
                            .updateShopWorkingHour_selectTime,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedWorkingHours[day] = newValue!;
                        });
                      },
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppSize.xSmallSize)),
                      items:
                          times.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            getLocalizedTime(value),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
