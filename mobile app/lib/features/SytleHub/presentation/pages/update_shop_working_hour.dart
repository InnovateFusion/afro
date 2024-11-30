import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/shop/shop_entity.dart';
import '../../domain/entities/shop/working_hour_entity.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_one.dart';

class UpdateShopWorkingHour extends StatefulWidget {
  const UpdateShopWorkingHour({super.key, required this.shop});

  final ShopEntity shop;

  @override
  State<UpdateShopWorkingHour> createState() => _UpdateShopWorkingHourState();
}

class _UpdateShopWorkingHourState extends State<UpdateShopWorkingHour> {
  @override
  void initState() {
    super.initState();
    setState(() {
      for (var day in widget.shop.workingHours) {
        selectedWorkingHours[day.day] = day.time;
        mapIdDays[day.day] = day.id;
      }
    });
  }

  Map<String, String> selectedWorkingHours = {};
  Map<String, String> mapIdDays = {};
  final List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  final List<String> times = [
    "morning",
    "afternoon",
    "evening",
    "all_day",
    "close"
  ];

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

  bool validateShopWorkingHour() {
    if (selectedWorkingHours.length != 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              AppLocalizations.of(context)!
                  .updateShopWorkingHour_selectWorkingHours,
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

  void onSaved() {
    if (validateShopWorkingHour()) {
      final List<WorkingHourEntity> workingHours = [];
      selectedWorkingHours.forEach((day, time) {
        workingHours.add(WorkingHourEntity(
          day: day,
          time: time,
          id: mapIdDays[day] ?? '123',
          shopId: widget.shop.id,
        ));
      });
      context.read<ShopBloc>().add(
            UpdateShopWorkingHourEvent(
              token: context.read<UserBloc>().state.user?.token ?? '',
              workingHours: workingHours,
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
                if (state.updateShopWorkingHourStatus ==
                    UpdateShopWorkingHourStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .updateShopWorkingHour_workingHoursUpdatedSuccessfully,
                          textAlign: TextAlign.center,
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
                } else if (state.updateShopWorkingHourStatus ==
                    UpdateShopWorkingHourStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
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
                          children: days
                              .map(
                                (day) => Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSize.xSmallSize),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            getLocalizedDay(day.toLowerCase()),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        DropdownButton<String>(
                                          value: selectedWorkingHours[day],
                                          hint: Text(
                                            AppLocalizations.of(context)!
                                                .updateShopWorkingHour_selectTime,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedWorkingHours[day] =
                                                  newValue!;
                                            });
                                          },
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  AppSize.xSmallSize)),
                                          items: times
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                getLocalizedTime(value),
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
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )),
                  ),
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
                              .updateShopWorkingHour_updateWorkingHours,
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
          if (context.watch<ShopBloc>().state.updateShopWorkingHourStatus ==
              UpdateShopWorkingHourStatus.loading)
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
