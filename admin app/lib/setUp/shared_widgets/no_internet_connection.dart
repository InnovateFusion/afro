import '../../core/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/no_internet.png',
            width: 340,
            height: 340,
          ),
          Text(
            "No Internet Connection",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          Text(
            "Please check your internet connection.",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: AppSize.mediumSize),
          context.watch<ProductBloc>().state.realTimeMessageStatus ==
                  ApiRequestStatus.connecting
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 12,
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    context.read<ProductBloc>().add(SignalRStartEvent());
                  },
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(AppSize.smallSize),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSize.largeSize),
                    ),
                    child: Text(
                      "Try Again",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
