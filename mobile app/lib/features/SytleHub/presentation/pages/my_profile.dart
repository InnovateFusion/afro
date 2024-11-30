import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as my_permission;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/product/domain_entity.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/CustomInputField.dart';
import 'location_picker.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? firstNameError;
  String? lastNameError;
  String? phoneError;

  Address? _currentAddress;
  Position? _currentPosition;
  DateTime? _selectedBirthday;
  String? _selectedGender;
  File? _logoImage;
  bool isPickUplocation = false;

  @override
  void initState() {
    firstNameController.text =
        context.read<UserBloc>().state.user?.firstName ?? '';
    lastNameController.text =
        context.read<UserBloc>().state.user?.lastName ?? '';
    phoneController.text =
        context.read<UserBloc>().state.user?.phoneNumber ?? '';
    _selectedGender = context.read<UserBloc>().state.user?.gender;
    _selectedBirthday = context.read<UserBloc>().state.user?.dateOfBirth;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void validateFirstName(String value) {
    if (value.isEmpty) {
      setState(() {
        firstNameError = value.isEmpty
            ? AppLocalizations.of(context)!.myProfileFirstNameCannotBeEmpty
            : null;
      });
    }

    if (firstNameController.text.length < 3) {
      setState(() {
        firstNameError =
            AppLocalizations.of(context)!.myProfileFirstNameMinLength;
      });
    } else {
      setState(() {
        firstNameError = null;
      });
    }
  }

  void validateLastName(String value) {
    setState(() {
      lastNameError = value.isEmpty
          ? AppLocalizations.of(context)!.myProfileLastNameCannotBeEmpty
          : null;
    });

    if (lastNameController.text.length < 3) {
      setState(() {
        lastNameError =
            AppLocalizations.of(context)!.myProfileLastNameMinLength;
      });
    } else {
      setState(() {
        lastNameError = null;
      });
    }
  }

  void validatePhone(String value) {
    setState(() {
      phoneError = value.isEmpty
          ? AppLocalizations.of(context)!.myProfilePhoneNumberCannotBeEmpty
          : null;
    });

    if (phoneController.text.length < 10) {
      setState(() {
        phoneError =
            AppLocalizations.of(context)!.myProfilePhoneNumberMinLength;
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
          toolbarTitle: AppLocalizations.of(context)!.myProfileCropperTitle,
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: AppLocalizations.of(context)!.myProfileCropperTitle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );

    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

  String listOfCategories(
      List<DomainEntity> domains, String gender, DateTime dateOfBirth) {
    Set<String> categories = {};
    for (int i = 0; i < domains.length; i++) {
      for (int j = 0; j < domains[i].subDomain.length; j++) {
        for (int k = 0; k < domains[i].subDomain[j].category.length; k++) {
          final int age = DateTime.now().year - dateOfBirth.year;

          if (age < 14) {
            if (domains[i].name.toLowerCase() == 'kids') {
              categories.add(domains[i].subDomain[j].category[k].id);
            }

            continue;
          }

          if (gender == 'male') {
            if (domains[i].name.toLowerCase() == 'men') {
              categories.add(domains[i].subDomain[j].category[k].id);
            }
            continue;
          }
          if (gender == 'female') {
            if (domains[i].name.toLowerCase() == 'women') {
              categories.add(domains[i].subDomain[j].category[k].id);
            }
            continue;
          }
        }
      }
    }

    return jsonEncode(categories.toList());
  }

  void onSubmit() {
    validateFirstName(firstNameController.text);
    validateLastName(lastNameController.text);
    validatePhone(phoneController.text);

    if (firstNameError == null &&
        lastNameError == null &&
        phoneError == null &&
        _selectedGender != null &&
        _selectedBirthday != null) {
      context.read<UserBloc>().add(
            UpdateProfileEvent(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              latitude: _currentPosition?.latitude,
              phoneNumber: phoneController.text,
              longitude: _currentPosition?.longitude,
              street: _currentAddress?.street,
              subLocality: _currentAddress?.subLocality,
              subAdministrativeArea: _currentAddress?.subAdministrativeArea,
              postalCode: _currentAddress?.postalCode,
              profilePicture: _logoImage,
              gender: _selectedGender,
              dateOfBirth: _selectedBirthday,
              productCategoryPreferences: listOfCategories(
                context.read<ProductBloc>().state.domains,
                _selectedGender!,
                _selectedBirthday!,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageLink = '';
    if (context.watch<UserBloc>().state.user != null) {
      imageLink = context.watch<UserBloc>().state.user!.profilePicture ?? '';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(AppSize.smallSize),
                child: Column(
                  children: [
                    Row(
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
                          AppLocalizations.of(context)!.myProfileTitle,
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
                    const SizedBox(height: AppSize.xxxLargeSize),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _logoImage != null
                              ? FileImage(_logoImage!) as ImageProvider
                              : imageLink.isNotEmpty
                                  ? NetworkImage(
                                      imageLink,
                                    ) as ImageProvider
                                  : const AssetImage(
                                      "assets/images/Screens/person.png",
                                    ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: pickLogoImage,
                            child: Container(
                              padding:
                                  const EdgeInsets.all(AppSize.xxSmallSize + 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSize.xxxLargeSize),
                    builderDetails(
                      AppLocalizations.of(context)!.myProfileFirstName,
                      CustomInputField(
                        controller: firstNameController,
                        hintText:
                            AppLocalizations.of(context)!.myProfileFirstName,
                        onChanged: validateFirstName,
                        errorText: firstNameError,
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    builderDetails(
                      AppLocalizations.of(context)!.myProfileLastName,
                      CustomInputField(
                        controller: lastNameController,
                        hintText:
                            AppLocalizations.of(context)!.myProfileLastName,
                        onChanged: validateLastName,
                        errorText: lastNameError,
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    builderDetails(
                      AppLocalizations.of(context)!.myProfilePhoneNumber,
                      CustomInputField(
                        controller: phoneController,
                        hintText:
                            AppLocalizations.of(context)!.myProfilePhoneNumber,
                        prefixIcon: Icons.phone,
                        onChanged: validatePhone,
                        errorText: phoneError,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    builderDetails(
                      AppLocalizations.of(context)!.myProfileSelectBirthday,
                      GestureDetector(
                        onTap: () async {
                          final DateTime now = DateTime.now();
                          final DateTime minAgeDate =
                              DateTime(now.year - 12, now.month, now.day);

                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: minAgeDate,
                            firstDate: DateTime(1900),
                            lastDate: minAgeDate,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedBirthday = picked;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.smallSize,
                              vertical: AppSize.xSmallSize),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius:
                                BorderRadius.circular(AppSize.xSmallSize),
                          ),
                          height: 60,
                          child: Row(
                            children: [
                              Text(
                                _selectedBirthday != null
                                    ? '${_selectedBirthday?.day}/${_selectedBirthday?.month}/${_selectedBirthday?.year}'
                                    : AppLocalizations.of(context)!
                                        .myProfileSelectBirthday,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    builderDetails(
                      AppLocalizations.of(context)!.myProfileSelectGender,
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.xSmallSize),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppSize.xSmallSize),
                        ),
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration.collapsed(
                                  hintText: _selectedGender != null
                                      ? Captilizations.capitalize(
                                          _selectedGender!)
                                      : AppLocalizations.of(context)!
                                          .myProfileSelectGender,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                                value: _selectedGender,
                                items: [
                                  {
                                    'value': 'male',
                                    'label': AppLocalizations.of(context)!
                                        .myProfileGenderMale
                                  },
                                  {
                                    'value': 'female',
                                    'label': AppLocalizations.of(context)!
                                        .myProfileGenderFemale
                                  },
                                ].map((gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender['value'],
                                    child: Text(
                                      gender['label']!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    builderDetails(
                      AppLocalizations.of(context)!.myProfilePickupAddress,
                      GestureDetector(
                        onTap: () async {
                          my_permission.PermissionStatus status =
                              await my_permission.Permission.location.request();

                          if (status ==
                              my_permission.PermissionStatus.granted) {
                            setState(() {
                              isPickUplocation = true;
                            });
                            try {
                              _currentPosition =
                                  await LocationHandler.getCurrentPosition();
                              if (_currentPosition == null) {
                              } else {
                                _currentAddress =
                                    await LocationHandler.getAddressFromLatLng(
                                        _currentPosition!);
                              }
                            } catch (e) {
                              await openAppSettings();
                            }
                            setState(() {
                              isPickUplocation = false;
                            });
                          } else if (status ==
                              my_permission.PermissionStatus.denied) {
                            await my_permission.Permission.location.request();
                          } else if (status ==
                              my_permission
                                  .PermissionStatus.permanentlyDenied) {
                            await openAppSettings();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.smallSize,
                              vertical: AppSize.xSmallSize),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius:
                                BorderRadius.circular(AppSize.xSmallSize),
                          ),
                          height: 65,
                          child: isPickUplocation
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      _currentAddress?.subAdministrativeArea !=
                                              null
                                          ? '${_currentAddress?.subAdministrativeArea}'
                                          : context
                                                      .read<UserBloc>()
                                                      .state
                                                      .user
                                                      ?.subAdministrativeArea !=
                                                  null
                                              ? '${context.read<UserBloc>().state.user?.subAdministrativeArea}'
                                              : AppLocalizations.of(context)!
                                                  .myProfilePickupAddress,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.location_on,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.xLargeSize),
                    GestureDetector(
                      onTap: onSubmit,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.smallSize),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              BorderRadius.circular(AppSize.xSmallSize),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.myProfileUpdateProfile,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSize.smallSize),
                  ],
                ),
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
