import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/size/app_size.dart';
import '../../../../setUp/url/urls.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/scroll/scroll_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_two.dart';
import '../widgets/shimmer/chat_list_tile_shimmer.dart';
import 'chat_detail.dart';
import 'user_search_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.openCloseDrawer});

  final VoidCallback openCloseDrawer;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;
  void _scrollListener() {
    if (_scrollEndTimer != null && _scrollEndTimer!.isActive) {
      _scrollEndTimer!.cancel();
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      context.read<ScrollBloc>().add(ToggleVisibilityEvent(isVisible: false));
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      context.read<ScrollBloc>().add(ToggleVisibilityEvent(isVisible: true));
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ChatBloc>().add(GetChatParticipantsEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
          ));
    }
  }

  String formatSecondsToTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChatBloc>().add(GetChatParticipantsEvent(
            token: context.read<UserBloc>().state.user?.token ?? ''));
      },
      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.all(AppSize.smallSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBarTwo(
              onTap: widget.openCloseDrawer,
            ),
            const SizedBox(height: AppSize.mediumSize),
            // Search bar
            GestureDetector(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                  context,
                  settings: const RouteSettings(name: '/chat/search'),
                  withNavBar: false,
                  screen: const UserSearchPage(),
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.smallSize,
                  vertical: AppSize.xSmallSize + 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: AppSize.smallSize),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context)!.chatScreenSearchHint,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSize.smallSize),
            if (context.watch<ChatBloc>().state.getChatParticipantsStatus ==
                GetChatParticipantsStatus.loading)
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return const ChatListTileShimmer();
                  },
                ),
              )
            else if (context
                        .watch<ChatBloc>()
                        .state
                        .getChatParticipantsStatus ==
                    GetChatParticipantsStatus.failure ||
                context.watch<ChatBloc>().state.getChatParticipantsStatus ==
                    GetChatParticipantsStatus.initial ||
                context.watch<ChatBloc>().state.chatParticipants.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Screens/no_connect.png'),
                    Text(
                      AppLocalizations.of(context)!.chatScreenNoMessages,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.chatScreenStartConversation,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const SizedBox(height: AppSize.xxxLargeSize),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      context.watch<ChatBloc>().state.chatParticipants.length,
                  itemBuilder: (context, index) {
                    final users = context
                        .watch<ChatBloc>()
                        .state
                        .chatParticipants
                        .values
                        .toList();
                    final user = users[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        PersistentNavBarNavigator
                            .pushNewScreenWithRouteSettings(
                          context,
                          settings: const RouteSettings(name: '/chat/detail'),
                          withNavBar: false,
                          screen: ChatPage(
                            receiver: user,
                          ),
                          pageTransitionAnimation: PageTransitionAnimation.fade,
                        );
                      },
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                            user.profilePicture ?? Urls.dummyImage),
                      ),
                      title: Text(
                        Captilizations.capitalizeFirstOfEach(
                            "${user.firstName} ${user.lastName}"),
                      ),
                      subtitle: Text(
                        user.lastMessage != null
                            ? user.lastMessage?.type == 1
                                ? AppLocalizations.of(context)!
                                    .chatScreenImageSent
                                : user.lastMessage?.message ??
                                    AppLocalizations.of(context)!
                                        .chatScreenNoMessage
                            : AppLocalizations.of(context)!.chatScreenNoMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      trailing: user.lastMessage != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  timeago.format(
                                      user.lastMessage?.createdAt ??
                                          DateTime.now(),
                                      clock: DateTime.now(),
                                      allowFromNow: true),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                                const SizedBox(width: AppSize.smallSize),
                                user.lastMessage?.senderId ==
                                        context.read<UserBloc>().state.user?.id
                                    ? user.lastMessage?.isRead ?? false
                                        ? Icon(
                                            Icons.done_all,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          )
                                        : Icon(
                                            Icons.done,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          )
                                    : user.lastMessage?.isRead ?? false
                                        ? const SizedBox()
                                        : Container(
                                            height: 18,
                                            width: 18,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.brightness_1,
                                                size: 10,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                            ),
                                          )
                              ],
                            )
                          : const SizedBox(),
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
