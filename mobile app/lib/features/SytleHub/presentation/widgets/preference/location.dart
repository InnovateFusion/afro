import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as my_permission;
import 'package:permission_handler/permission_handler.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../pages/location_picker.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker(
      {super.key,
      required this.onLocationSelected,
      this.selectedAddress,
      this.selectedPosition});

  final void Function(Address address, Position position) onLocationSelected;
  final Address? selectedAddress;
  final Position? selectedPosition;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool isPickUplocation = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Image.asset(
            'assets/images/Screens/location.png',
            fit: BoxFit.contain,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.preference_select_location,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: AppSize.mediumSize),
        GestureDetector(
          onTap: () async {
            my_permission.PermissionStatus status =
                await my_permission.Permission.location.request();

            if (status == my_permission.PermissionStatus.granted) {
              try {
                setState(() {
                  isPickUplocation = true;
                });
                final currentPosition =
                    await LocationHandler.getCurrentPosition();
                if (currentPosition != null) {
                  final currentAddress =
                      await LocationHandler.getAddressFromLatLng(
                          currentPosition);

                  widget.onLocationSelected(currentAddress!, currentPosition);
                }
                setState(() {
                  isPickUplocation = false;
                });
              } catch (e) {
                await openAppSettings();
              }
              setState(() {
                isPickUplocation = false;
              });

              setState(() {
                isPickUplocation = false;
              });
            } else if (status == my_permission.PermissionStatus.denied) {
              await my_permission.Permission.location.request();
              await openAppSettings();
            } else if (status ==
                my_permission.PermissionStatus.permanentlyDenied) {
              await openAppSettings();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.smallSize, vertical: AppSize.xSmallSize),
            child: isPickUplocation
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.xSmallSize),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              BorderRadius.circular(AppSize.largeSize),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.selectedAddress != null
                                  ? widget
                                      .selectedAddress!.subAdministrativeArea
                                  : AppLocalizations.of(context)!
                                      .preference_my_location,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                            const SizedBox(width: AppSize.xSmallSize),
                            Icon(
                              Icons.location_on,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
