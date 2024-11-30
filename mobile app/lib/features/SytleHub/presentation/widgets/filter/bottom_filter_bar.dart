import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../../setUp/size/app_size.dart';

class BottomFilterBar extends StatelessWidget {
  const BottomFilterBar(
      {super.key,
      required this.onTapClear,
      required this.onTapResult,
      required this.isAdd});

  final Function() onTapClear;
  final Function() onTapResult;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: onTapClear,
            child: Text(AppLocalizations.of(context)!.filter_clear,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface))),
        GestureDetector(
          onTap: onTapResult,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.smallSize, vertical: AppSize.xSmallSize),
            margin: const EdgeInsets.only(right: AppSize.smallSize),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
            ),
            child: Text(
                isAdd
                    ? AppLocalizations.of(context)!.filter_add
                    : AppLocalizations.of(context)!.filter_result,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )),
          ),
        ),
      ],
    );
  }
}
