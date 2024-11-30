import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/product/product_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../setUp/size/app_size.dart';

class SizePreference extends StatelessWidget {
  final Set<String> selectedSizes;
  final Function(String) onSelected;

  const SizePreference(
      {super.key, required this.selectedSizes, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
        AppLocalizations.of(context)!.preference_select_favorite_sizes,
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
        SizedBox(
          height: 340,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              children: [
                for (final size in context.read<ProductBloc>().state.sizes)
                  GestureDetector(
                    onTap: () {
                      onSelected(size.id);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.all(AppSize.xSmallSize),
                      decoration: BoxDecoration(
                        color: selectedSizes.contains(size.id)
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppSize.xxxLargeSize),
                        border: Border.all(
                          color: selectedSizes.contains(size.id)
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          size.abbreviation.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: selectedSizes.contains(size.id)
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSize.smallSize),
      ],
    );
  }
}
