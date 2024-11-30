import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../setUp/size/app_size.dart';

class BirthDatePicker extends StatefulWidget {
  const BirthDatePicker(
      {super.key, required this.onBirthDateSelected, this.selectedBirthDate});

  final void Function(DateTime gender) onBirthDateSelected;
  final DateTime? selectedBirthDate;

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Image.asset(
            'assets/images/Screens/calander.png',
            fit: BoxFit.contain,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.preference_pick_birth_date,
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
              widget.onBirthDateSelected(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.smallSize, vertical: AppSize.xSmallSize),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSize.xSmallSize),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.selectedBirthDate != null
                      ? '${widget.selectedBirthDate?.day}/${widget.selectedBirthDate?.month}/${widget.selectedBirthDate?.year}'
                      : AppLocalizations.of(context)!.preference_date_format,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(width: AppSize.xSmallSize),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
