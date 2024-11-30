import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../setUp/size/app_size.dart';

class NoSearchResult extends StatelessWidget {
  const NoSearchResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.smallSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              child: Image.asset('assets/images/Screens/no_search_result.png'),
            ),
            const SizedBox(height: AppSize.smallSize),
            Text(
              AppLocalizations.of(context)!.noSearchResult_title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: AppSize.xxxLargeSize),
          ],
        ),
      ),
    );
  }
}
