import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../../../setUp/language/localize.dart';

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<Locale>(
          value: context.watch<LanguageBloc>().state.locale,
          dropdownColor: Theme.of(context).colorScheme.scrim,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              context
                  .read<LanguageBloc>()
                  .add(ChangeLanguageEvent(locale: newLocale));
            }
          },
          items: L10n.all.map((locale) {
            final flag = L10n.getFlag(locale.languageCode);
            return DropdownMenuItem(
              value: locale,
              child: Text(flag,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
            );
          }).toList(),
        )
      ],
    );
  }
}
