import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../setUp/size/app_size.dart';

class WellCome extends StatelessWidget {
  const WellCome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Image.asset(
            'assets/icons/Afro.png',
            fit: BoxFit.contain,
            width: 200,
          ),
        ),
        const SizedBox(height: AppSize.smallSize - 4),
        Text(
          AppLocalizations.of(context)!.preference_welcome,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: AppSize.xSmallSize),
        Text(
          AppLocalizations.of(context)!.preference_get_started,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ],
    );
  }
}
