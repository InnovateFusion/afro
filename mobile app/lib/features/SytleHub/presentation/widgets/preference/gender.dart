import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../setUp/size/app_size.dart';

class GenderPicker extends StatefulWidget {
  const GenderPicker(
      {super.key, required this.onGenderSelected, this.selectedGender});

  final void Function(int gender) onGenderSelected;
  final int? selectedGender;

  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Image.asset(
            'assets/images/Screens/gender.png',
            fit: BoxFit.contain,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.preference_gender_selection,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onGenderSelected(1);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: widget.selectedGender == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.male,
                      color: widget.selectedGender == 1
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.preference_male),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onGenderSelected(2);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: widget.selectedGender == 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.female,
                      color: widget.selectedGender == 2
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.preference_female),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
