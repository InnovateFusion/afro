import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/size/app_size.dart';
import '../../../../setUp/url/urls.dart';
import '../../domain/entities/chat/chat_participant_entity.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/no_search_result.dart';
import '../widgets/shimmer/chat_list_tile_shimmer.dart';
import 'chat_detail.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ChatBloc>().add(
            SearchUserEvent(
              query: searchController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = context
        .watch<ChatBloc>()
        .state
        .searchUsers
        .where((user) => user.id != context.read<UserBloc>().state.user?.id)
        .toList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.smallSize),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<ChatBloc>().add(
                            const SearchUserEvent(
                              query: '',
                            ),
                          );
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: AppSize.smallSize),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.search_for_user,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            context.read<ChatBloc>().add(
                                  const SearchUserEvent(
                                    query: '',
                                  ),
                                );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.smallSize),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        context.read<ChatBloc>().add(
                              SearchUserEvent(
                                query: searchController.text,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              height: 1,
            ),
            Expanded(
              child: context.watch<ChatBloc>().state.searchUserStatus ==
                      SearchUserStatus.loading
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize,
                        vertical: AppSize.xSmallSize,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return const ChatListTileShimmer();
                      },
                    )
                  : (context.watch<ChatBloc>().state.searchUsers.isEmpty &&
                          (context.watch<ChatBloc>().state.searchUserStatus ==
                                  SearchUserStatus.success ||
                              context
                                      .watch<ChatBloc>()
                                      .state
                                      .searchUserStatus ==
                                  SearchUserStatus.failure ||
                              context
                                      .watch<ChatBloc>()
                                      .state
                                      .searchUserStatus ==
                                  SearchUserStatus.noMore))
                      ? const NoSearchResult()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.xSmallSize,
                          ),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () {
                                PersistentNavBarNavigator
                                    .pushNewScreenWithRouteSettings(
                                  context,
                                  settings:
                                      const RouteSettings(name: '/chat/detail'),
                                  withNavBar: false,
                                  screen: ChatPage(
                                    receiver: ChatParticipantEntity(
                                        id: user.id,
                                        firstName: user.firstName,
                                        lastName: user.lastName,
                                        email: user.email,
                                        chatEntities: const []),
                                  ),
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.fade,
                                );
                              },
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                    user.profilePicture ?? Urls.dummyImage),
                              ),
                              title: Text(
                                "${user.firstName} ${user.lastName}".substring(
                                    0,
                                    "${user.firstName} ${user.lastName}"
                                                .length >
                                            20
                                        ? 20
                                        : "${user.firstName} ${user.lastName}"
                                            .length),
                              ),
                            );
                          },
                        ),
            ),
            if (context.watch<ChatBloc>().state.searchUserStatus ==
                SearchUserStatus.loadMore)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
