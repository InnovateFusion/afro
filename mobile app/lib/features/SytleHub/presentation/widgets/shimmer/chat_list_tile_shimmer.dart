import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../setUp/size/app_size.dart';

class ChatListTileShimmer extends StatelessWidget {
  const ChatListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        title: Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }
}
