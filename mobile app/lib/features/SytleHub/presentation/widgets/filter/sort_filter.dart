import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../bloc/product_filter/product_filter_bloc.dart';

class SortFilterDisplay extends StatefulWidget {
  const SortFilterDisplay({
    super.key,
  });

  @override
  State<SortFilterDisplay> createState() => _SortFilterDisplayState();
}

class _SortFilterDisplayState extends State<SortFilterDisplay> {
  @override
  Widget build(BuildContext context) {
    List<String> sorts = [
      AppLocalizations.of(context)!.filter_newest_arrivals,
      AppLocalizations.of(context)!.filter_oldest,
      AppLocalizations.of(context)!.filter_price_low_high,
      AppLocalizations.of(context)!.filter_price_high_low,
    ];

    const List<Map<String, String>> sortOrder = [
      {"name": "date", "order": "desc"},
      {"name": "date", "order": "asc"},
      {"name": "price", "order": "asc"},
      {"name": "price", "order": "desc"}
    ];
    return Padding(
      padding: const EdgeInsets.all(AppSize.smallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.filter_sort_by,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.smallSize),
          Wrap(
            spacing: AppSize.smallSize,
            runSpacing: AppSize.smallSize,
            children: [
              for (int index = 0; index < sorts.length; index++)
                GestureDetector(
                  onTap: () {
                    context.read<ProductFilterBloc>().add(SetSortByEvent(
                        sortOrder[index]['name'] ?? '',
                        sortOrder[index]['order'] ?? ''));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize,
                        vertical: AppSize.xxSmallSize),
                    decoration: context.watch<ProductFilterBloc>().state.sort ==
                                sortOrder[index]['name'] &&
                            context.watch<ProductFilterBloc>().state.order ==
                                sortOrder[index]['order']
                        ? BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            borderRadius:
                                BorderRadius.circular(AppSize.xxSmallSize),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          )
                        : BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSize.xxSmallSize),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                            ),
                          ),
                    child: Text(
                      Captilizations.capitalize(sorts[index]),
                      style: context.watch<ProductFilterBloc>().state.sort ==
                                  sortOrder[index]['name'] &&
                              context.watch<ProductFilterBloc>().state.order ==
                                  sortOrder[index]['order']
                          ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary)
                          : Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
