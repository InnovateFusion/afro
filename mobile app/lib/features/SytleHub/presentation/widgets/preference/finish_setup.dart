import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../setUp/size/app_size.dart';

class FinishSetup extends StatelessWidget {
  const FinishSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/Screens/finish.png',
          fit: BoxFit.contain,
        ),
        const SizedBox(height: AppSize.smallSize - 4),
        Text(
          AppLocalizations.of(context)!.preference_thank_you,
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
          AppLocalizations.of(context)!.preference_start_using,
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
