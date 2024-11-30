import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../domain/entities/shop/shop_entity.dart';
import '../bloc/user/user_bloc.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../widgets/common/app_bar_one.dart';
import '../widgets/common/custom_input_field_product.dart';
import 'location_picker.dart';

class UpdateShopBasicInfo extends StatefulWidget {
  const UpdateShopBasicInfo({super.key, required this.shop});

  final ShopEntity shop;

  @override
  State<UpdateShopBasicInfo> createState() => _UpdateShopBasicInfoState();
}

class _UpdateShopBasicInfoState extends State<UpdateShopBasicInfo> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  List<String> selectedCategories = [];
  bool isPickUplocation = false;

  String? nameError;
  String? descriptionError;
  String? phoneError;
  String? websiteError;
  Address? _currentAddress;
  Position? _currentPosition;

  @override
  void initState() {
    nameController.text = widget.shop.name;
    descriptionController.text = widget.shop.description;
    phoneController.text = widget.shop.phoneNumber;
    if (widget.shop.website != null) {
      websiteController.text = widget.shop.website!;
    }
    setState(() {
      nameError = null;
      descriptionError = null;
      phoneError = null;
      websiteError = null;
      selectedCategories = widget.shop.categories;
    });

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    super.dispose();
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

  void onSaved() {
    if (isPickUplocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!
                  .updateShopBasicInfo_waitingForLocation,
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

    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!.updateShopBasicInfo_selectCategory,
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
    validateName(nameController.text);
    validateDescription(descriptionController.text);
    validatePhone(phoneController.text);

    if (nameError == null && descriptionError == null && phoneError == null) {
      context.read<ShopBloc>().add(
            UpdateShopEvent(
              name: nameController.text ==
                      context.read<ShopBloc>().state.shops[widget.shop.id]?.name
                  ? null
                  : nameController.text,
              description: descriptionController.text,
              categories: selectedCategories,
              phone: phoneController.text,
              website: websiteController.text,
              street: _currentAddress != null
                  ? _currentAddress!.street
                  : widget.shop.street,
              subAdministrativeArea: _currentAddress != null
                  ? _currentAddress!.subAdministrativeArea
                  : widget.shop.subAdministrativeArea,
              subLocality: _currentAddress != null
                  ? _currentAddress!.subLocality
                  : widget.shop.subLocality,
              postalCode: _currentAddress != null
                  ? _currentAddress!.postalCode
                  : widget.shop.postalCode,
              latitude: _currentPosition != null
                  ? _currentPosition!.latitude
                  : widget.shop.latitude,
              longitude: _currentPosition != null
                  ? _currentPosition!.longitude
                  : widget.shop.longitude,
              shopId: widget.shop.id,
              token: context.read<UserBloc>().state.user?.token ?? '',
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!
                  .updateShopBasicInfo_fillRequiredFields,
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
                              .updateShopBasicInfo_shopUpdatedSuccessfully,
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
                        children: [
                          builderDetails(
                            AppLocalizations.of(context)!
                                .updateShopBasicInfo_name,
                            CustomInputFieldProduct(
                              controller: nameController,
                              hintText: AppLocalizations.of(context)!
                                  .updateShopBasicInfo_name,
                              errorText: nameError,
                              onChanged: validateName,
                            ),
                          ),
                          const SizedBox(height: AppSize.smallSize),
                          builderDetails(
                            AppLocalizations.of(context)!
                                .updateShopBasicInfo_description,
                            CustomInputFieldProduct(
                              controller: descriptionController,
                              hintText: AppLocalizations.of(context)!
                                  .updateShopBasicInfo_description,
                              errorText: descriptionError,
                              onChanged: validateDescription,
                              maxLines: 5,
                            ),
                          ),
                          const SizedBox(height: AppSize.smallSize),
                          builderDetails(
                            AppLocalizations.of(context)!
                                .updateShopBasicInfo_selectCategory,
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppSize.xSmallSize),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: MultiSelectDialogField(
                                items: [
                                  MultiSelectItem(
                                    "men's fashion",
                                    AppLocalizations.of(context)!
                                        .updateShopBasicInfo_mensFashion,
                                  ),
                                  MultiSelectItem(
                                    "women's fashion",
                                    AppLocalizations.of(context)!
                                        .updateShopBasicInfo_womensFashion,
                                  ),
                                  MultiSelectItem(
                                    "kids fashion",
                                    AppLocalizations.of(context)!
                                        .updateShopBasicInfo_kidsFashion,
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
                                    AppLocalizations.of(context)!
                                        .updateShopBasicInfo_other,
                                  ),
                                ],
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .updateShopBasicInfo_selectCategory,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                                selectedColor:
                                    Theme.of(context).colorScheme.secondary,
                                selectedItemsTextStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.xSmallSize),
                                  ),
                                ),
                                buttonText: Text(
                                  AppLocalizations.of(context)!
                                      .updateShopBasicInfo_selectCategory,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                            AppLocalizations.of(context)!
                                .updateShopBasicInfo_phone,
                            CustomInputFieldProduct(
                              controller: phoneController,
                              hintText: AppLocalizations.of(context)!
                                  .updateShopBasicInfo_phone,
                              errorText: phoneError,
                              onChanged: validatePhone,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(height: AppSize.smallSize),
                          builderDetails(
                            AppLocalizations.of(context)!
                                .updateShopBasicInfo_websiteOptional,
                            CustomInputFieldProduct(
                              controller: websiteController,
                              hintText: AppLocalizations.of(context)!
                                  .updateShopBasicInfo_websiteOptional,
                              errorText: websiteError,
                              keyboardType: TextInputType.url,
                            ),
                          ),
                          const SizedBox(height: AppSize.smallSize),
                          builderDetails(
                            AppLocalizations.of(context)!
                                .updateShopBasicInfo_pickupAddress,
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isPickUplocation = true;
                                });
                                _currentPosition =
                                    await LocationHandler.getCurrentPosition();
                                _currentAddress =
                                    await LocationHandler.getAddressFromLatLng(
                                        _currentPosition!);

                                setState(() {
                                  isPickUplocation = false;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.smallSize,
                                    vertical: AppSize.xSmallSize),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.xSmallSize),
                                ),
                                height: 60,
                                child: isPickUplocation
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            _currentAddress
                                                        ?.subAdministrativeArea !=
                                                    null
                                                ? '${_currentAddress?.subAdministrativeArea}, ${_currentAddress?.subLocality}'
                                                : '${widget.shop.subAdministrativeArea}, ${widget.shop.subLocality}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.location_on,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSize.largeSize),
                          GestureDetector(
                            onTap: onSaved,
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius:
                                    BorderRadius.circular(AppSize.xxSmallSize),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .updateShopBasicInfo_updateBasicInfo,
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
                          ),
                        ],
                      ),
                    ),
                  )
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
