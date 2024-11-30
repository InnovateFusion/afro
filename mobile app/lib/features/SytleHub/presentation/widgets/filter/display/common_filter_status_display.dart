import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../../../setUp/size/app_size.dart';

class CommonFilterStatusDisplay extends StatelessWidget {
  const CommonFilterStatusDisplay(
      {super.key,
      required this.content,
      required this.onTap,
      required this.text});

  final Widget content;
  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.smallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  AppLocalizations.of(context)!.filter_view_all,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
            ],
          ),
          content,
        ],
      ),
    );
  }
}
