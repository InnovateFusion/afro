import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/user/notification_entity.dart';
import '../bloc/notification/notification_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/shimmer/chat_list_tile_shimmer.dart';
import 'product_detail_from_notification.dart';
import 'shop_detail.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(SetCountToZeroEvent());
    context.read<NotificationBloc>().add(GetNotificationsEvent(
        token: context.read<UserBloc>().state.user?.token ?? ''));
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<NotificationBloc>().add(GetNotificationsEvent(
          token: context.read<UserBloc>().state.user?.token ?? ''));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void viewDetail(NotificationEntity notification) {
    if ((notification.type == 6 || notification.type == 4) ||
        (notification.messageType == 2 && notification.type == 5)) {
      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        context,
        settings: const RouteSettings(name: '/product_detail'),
        withNavBar: false,
        screen: ProductDetailFromNotification(productId: notification.typeId),
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
    } else if (notification.type == 5) {
      showFullScreenMessage(context, notification);
    } else if (notification.type == 2) {
      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        context,
        settings: const RouteSettings(name: '/shop/DetailedReview'),
        withNavBar: false,
        screen: ShopDetail(shopId: notification.typeId),
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
    }
  }

  void showFullScreenMessage(
      BuildContext context, NotificationEntity notification) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        insetPadding: const EdgeInsets.all(AppSize.smallSize),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(AppSize.mediumSize),
          ),
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              NetworkImage(notification.sender.profilePicture),
                        ),
                        const SizedBox(width: AppSize.xSmallSize),
                        Flexible(
                          child: Text(
                            Captilizations.capitalize(
                                "${notification.sender.firstName} ${notification.sender.lastName}"),
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(width: AppSize.xxSmallSize),
                        if (notification.type == 5)
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.blueAccent.withOpacity(0.8),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.smallSize),
              Text(
                notification.message.trim(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget messageView(NotificationEntity notification) {
    if (notification.type == 1) {
      if (notification.messageType == 1) {
        return Image.network(
          notification.message,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        );
      } else {
        return Text(
          "${AppLocalizations.of(context)!.message}: ${notification.message}",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        );
      }
    } else if (notification.type == 2) {
      return Text(
        "${AppLocalizations.of(context)!.review}: ${notification.message.trim()}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      );
    } else if (notification.type == 5) {
      return Text(
        notification.message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      );
    }
    return Text(
      notification.message,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.smallSize),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    localization.notificationTitle,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(width: AppSize.xLargeSize),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              thickness: 1,
            ),
            if (context.watch<NotificationBloc>().state.notificationStatus ==
                NotificationStatus.loading)
              Expanded(
                child: ListView.builder(
                  itemCount: 14,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
                  itemBuilder: (context, index) {
                    return const ChatListTileShimmer();
                  },
                ),
              )
            else if (context
                .watch<NotificationBloc>()
                .state
                .notifications
                .isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSize.smallSize),
                    child: Column(
                      children: [
                        const SizedBox(height: 130),
                        Image.asset(
                          'assets/images/Screens/no_data.png',
                          width: 300,
                          height: 300,
                        ),
                        const SizedBox(height: AppSize.xSmallSize),
                        Text(
                          localization.notificationNoNotification,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: context
                      .watch<NotificationBloc>()
                      .state
                      .notifications
                      .length,
                  itemBuilder: (context, index) {
                    final notification = context
                        .watch<NotificationBloc>()
                        .state
                        .notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(notification.sender.profilePicture),
                      ),
                      isThreeLine: true,
                      title: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${notification.sender.firstName}  ${notification.sender.lastName}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          if (notification.type == 5)
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blueAccent.withOpacity(0.8),
                            ),
                        ],
                      ),
                      subtitle: messageView(notification),
                      trailing: notification.type == 5 ||
                              notification.type == 6 ||
                              notification.type == 4 ||
                              notification.type == 2
                          ? GestureDetector(
                              onTap: () => viewDetail(notification),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSize.xSmallSize,
                                    horizontal: AppSize.smallSize),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(
                                      AppSize.xxLargeSize),
                                ),
                                child: Text(
                                  localization.notificationView,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
