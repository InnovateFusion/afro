import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../../../../setUp/url/urls.dart';

class UpdateAppVersion extends StatelessWidget {
  const UpdateAppVersion({super.key});

  Future<void> launchPlayStore() async {
    const url = Urls.playStoreUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
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
            padding: const EdgeInsets.all(AppSize.largeSize),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(AppSize.largeSize),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSize.smallSize),
                  child: Image.asset(
                    'assets/icons/logo.png',
                    fit: BoxFit.contain,
                    width: 200,
                  ),
                ),
                Text(
                  localization.update_available,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSize.smallSize),
                Text(
                  localization.update_message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: AppSize.largeSize),
                ElevatedButton(
                  onPressed: launchPlayStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.largeSize),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSize.xSmallSize + 4),
                    child: Text(
                      localization.update_now,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
