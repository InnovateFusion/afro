import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../../../../setUp/size/app_size.dart';

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
            AppLocalizations.of(context)!.noInternetConnection,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          Text(
            AppLocalizations.of(context)!.checkYourConnection,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: AppSize.mediumSize),
          context.watch<ChatBloc>().state.status ==
                  RealTimeMessageStatus.connecting
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
                    context.read<ChatBloc>().add(SignalRStartEvent());
                  },
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(AppSize.smallSize),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSize.largeSize),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.tryAgain,
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
