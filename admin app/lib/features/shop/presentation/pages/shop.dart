import 'dart:async';

import 'package:afro_shop_admin/features/shop/presentation/widgets/shop_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../core/utils/enum.dart';
import '../../../../setUp/shared_widgets/drop_down_menu.dart';
import '../../../../setUp/size/app_size.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../shared/presentation/bloc/scroll/scroll_bloc.dart';
import '../bloc/shop_bloc.dart';
import '../widgets/shop_shimmer.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

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
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageLink = '';
    if (context.watch<AuthBloc>().state.user != null) {
      imageLink = context.watch<AuthBloc>().state.user!.profilePicture ?? '';
    }
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.all(AppSize.smallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: imageLink.isNotEmpty
                        ? Image.network(
                            imageLink,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/Screens/person.png",
                              );
                            },
                          )
                        : Image.asset(
                            "assets/images/Screens/person.png",
                          ),
                  ),
                  const SizedBox(width: AppSize.xSmallSize),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ${context.watch<AuthBloc>().state.user?.firstName ?? ''}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1,
                            ),
                      ),
                      Text(
                        Captilizations.capitalize(
                            context.watch<AuthBloc>().state.user?.role?.name ??
                                'User'),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              height: 1,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const DropDownMenu()
            ],
          ),
          const SizedBox(height: AppSize.smallSize),
          Text(
            'Shops',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1,
                ),
          ),
          const SizedBox(height: AppSize.smallSize),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              child: (context.watch<ShopBloc>().state.shopRequestStatus ==
                      ApiRequestStatus.loading)
                  ? Wrap(
                      spacing: AppSize.smallSize,
                      runSpacing: AppSize.smallSize,
                      children: List.generate(
                        6,
                        (index) => const ShopShimmer(),
                      ),
                    )
                  : context.watch<ShopBloc>().state.shops.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSize.smallSize),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 100),
                                Image.asset(
                                  'assets/images/Screens/no_data.png',
                                  width: 300,
                                  height: 300,
                                ),
                                const SizedBox(height: AppSize.xSmallSize),
                                Text(
                                  'No products available',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: AppSize.smallSize,
                          runSpacing: AppSize.smallSize,
                          children: context
                              .watch<ShopBloc>()
                              .state
                              .shops
                              .map((e) => ShopCard(
                                    shop: e,
                                  ))
                              .toList(),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
