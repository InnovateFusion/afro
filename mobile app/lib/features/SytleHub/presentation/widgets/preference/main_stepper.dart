import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../../domain/entities/product/domain_entity.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../pages/location_picker.dart';
import 'birthdate.dart';
import 'finish_setup.dart';
import 'gender.dart';
import 'location.dart';
import 'well_come.dart';

class MainStepper extends StatefulWidget {
  const MainStepper({super.key});

  @override
  State<MainStepper> createState() => _MainStepperState();
}

class _MainStepperState extends State<MainStepper> {
  int _currentStep = 0;
  int? _gender;
  DateTime? _birthDate;
  Address? _currentAddress;
  Position? _currentPosition;
  final Set<String> _selectedBrands = {};
  final Set<String> _selectedColors = {};
  final Set<String> _selectedSizes = {};
  final int _stepper = 5;

  void onStepContinue() {
    if (_currentStep == 1 && _gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.preference_select_gender,
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
    if (_currentStep == 2 && _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.preference_select_birth_date,
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

    if (_currentStep == 3 && _currentAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.preference_select_location,
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
    setState(() {
      if (_currentStep < _stepper - 1) {
        _currentStep += 1;
      } else {
        _currentStep = _stepper - 1;
      }
    });
  }

  void onStepCancel() {
    setState(() {
      if (_currentStep > 1) {
        _currentStep -= 1;
      } else {
        _currentStep = 1;
      }
    });
  }

  void onGenderSelected(int gender) {
    setState(() {
      _gender = gender;
    });
  }

  void onBirthDateSelected(DateTime birthDate) {
    setState(() {
      _birthDate = birthDate;
    });
  }

  void onLocationSelected(Address address, Position position) {
    setState(() {
      _currentAddress = address;
      _currentPosition = position;
    });
  }

  void onBrandSelected(String brand) {
    setState(() {
      if (_selectedBrands.contains(brand)) {
        _selectedBrands.remove(brand);
      } else {
        _selectedBrands.add(brand);
      }
    });
  }

  void onColorSelected(String color) {
    setState(() {
      if (_selectedColors.contains(color)) {
        _selectedColors.remove(color);
      } else {
        _selectedColors.add(color);
      }
    });
  }

  void onSizeSelected(String size) {
    setState(() {
      if (_selectedSizes.contains(size)) {
        _selectedSizes.remove(size);
      } else {
        _selectedSizes.add(size);
      }
    });
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

  void onFinished() {
    context.read<UserBloc>().add(UpdateProfileEvent(
          gender: _gender == 1 ? 'male' : 'female',
          dateOfBirth: _birthDate,
          latitude: _currentPosition?.latitude,
          longitude: _currentPosition?.longitude,
          subLocality: _currentAddress?.subLocality,
          subAdministrativeArea: _currentAddress?.subAdministrativeArea,
          postalCode: _currentAddress?.postalCode,
          street: _currentAddress?.street,
          productBrandPreferences: jsonEncode(_selectedBrands.toList()),
          productColorPreferences: jsonEncode(_selectedColors.toList()),
          productSizePreferences: jsonEncode(_selectedSizes.toList()),
          productCategoryPreferences: listOfCategories(
              context.read<ProductBloc>().state.domains,
              _gender == 1 ? 'male' : 'female',
              _birthDate!),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
            : Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.largeSize,
          vertical: AppSize.xSmallSize,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.mediumSize),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(AppSize.mediumSize),
              child: Column(
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      if (_currentStep == 0)
                        const WellCome()
                      else if (_currentStep == 1)
                        GenderPicker(
                          selectedGender: _gender,
                          onGenderSelected: onGenderSelected,
                        )
                      else if (_currentStep == 2)
                        BirthDatePicker(
                            onBirthDateSelected: onBirthDateSelected,
                            selectedBirthDate: _birthDate)
                      else if (_currentStep == 3)
                        LocationPicker(
                          onLocationSelected: onLocationSelected,
                          selectedPosition: _currentPosition,
                          selectedAddress: _currentAddress,
                        )
                      // else if (_currentStep == 4)
                      //   BrandPreference(
                      //     onSelected: onBrandSelected,
                      //     selectedBrands: _selectedBrands,
                      //   )
                      // else if (_currentStep == 4)
                      //   ColorPreference(
                      //     onSelected: onColorSelected,
                      //     selectedColors: _selectedColors,
                      //   )
                      // else if (_currentStep == 5)
                      //   SizePreference(
                      //     onSelected: onSizeSelected,
                      //     selectedSizes: _selectedSizes,
                      //   )
                      else if (_currentStep == 4)
                        const FinishSetup()
                      else
                        const SizedBox(),
                      const Row(
                        children: [
                          SizedBox(height: AppSize.mediumSize),
                        ],
                      ),
                      if (_currentStep > 0 && _currentStep < _stepper - 1)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 1; i < _stepper - 1; i++)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _currentStep >= i
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                      borderRadius: BorderRadius.circular(
                                        AppSize.xxSmallSize,
                                      ),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: AppSize.xxSmallSize,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.smallSize,
                                      vertical: AppSize.xxSmallSize,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSize.mediumSize),
                          ],
                        ),
                      if (_currentStep == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onStepContinue,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.xSmallSize),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.mediumSize,
                                  vertical: AppSize.xSmallSize,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .preference_continue,
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
                        )
                      else if (_currentStep == _stepper - 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onFinished,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.xSmallSize),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.mediumSize,
                                  vertical: AppSize.xSmallSize,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .preference_start_shopping,
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
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: onStepCancel,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                padding:
                                    const EdgeInsets.all(AppSize.xSmallSize),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: AppSize.xSmallSize),
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      size: AppSize.smallSize,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: onStepContinue,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                padding:
                                    const EdgeInsets.all(AppSize.xSmallSize),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  size: AppSize.smallSize,
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
