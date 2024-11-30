import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/product_filter/product_filter_bloc.dart';

class OtherFilterDisplay extends StatelessWidget {
  const OtherFilterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Access localization

    return Padding(
      padding: const EdgeInsets.all(AppSize.xSmallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.xSmallSize),
            child: Row(
              children: [
                Text(
                  localizations.status, // Localized "Status"
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: AppSize.xSmallSize,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value:
                        context.watch<ProductFilterBloc>().state.isNegotiable ??
                            false,
                    checkColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    onChanged: (value) {
                      context
                          .read<ProductFilterBloc>()
                          .add(SetIsNegotiableEvent(value!));
                    },
                  ),
                  Text(
                    localizations.negotiable, // Localized "Negotiable"
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: context.watch<ProductFilterBloc>().state.inStock ??
                          false,
                      checkColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      onChanged: (value) {
                        context
                            .read<ProductFilterBloc>()
                            .add(SetInStockEvent(value!));
                      },
                    ),
                    Text(
                      localizations.inStock, // Localized "In Stock"
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value:
                        context.watch<ProductFilterBloc>().state.isNew ?? false,
                    checkColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    onChanged: (value) {
                      context
                          .read<ProductFilterBloc>()
                          .add(SetIsNewEvent(value!));
                    },
                  ),
                  Text(
                    localizations.isNew, // Localized "New"
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: context
                            .watch<ProductFilterBloc>()
                            .state
                            .isDeliverable ??
                        false,
                    checkColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    onChanged: (value) {
                      context
                          .read<ProductFilterBloc>()
                          .add(SetIsDeliverableEvent(value!));
                    },
                  ),
                  Text(
                    localizations.deliverable, // Localized "Deliverable"
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
