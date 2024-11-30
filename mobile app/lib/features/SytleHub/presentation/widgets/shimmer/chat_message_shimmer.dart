import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../setUp/size/app_size.dart';

class ChatMessageShimmer extends StatelessWidget {
  final bool isSender;

  const ChatMessageShimmer({super.key, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppSize.smallSize,
          left: AppSize.smallSize,
          right: AppSize.smallSize),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.primaryContainer,
        highlightColor: Theme.of(context).colorScheme.onPrimary,
        child: Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender)
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            const SizedBox(width: AppSize.smallSize),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSize.smallSize, horizontal: 14),
              constraints: const BoxConstraints(
                maxWidth: 200,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.smallSize),
              ),
              child: const SizedBox(
                height: 16,
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
