import 'dart:async';

import '../../../../core/utils/captilizations.dart';
import '../../../../core/utils/enum.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../setUp/shared_widgets/drop_down_menu.dart';
import '../../../../setUp/size/app_size.dart';
import '../../../shared/presentation/bloc/scroll/scroll_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/product_shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        _scrollController.position.maxScrollExtent) {
      context.read<ProductBloc>().add(GetProductsEvent(
            token: context.read<AuthBloc>().state.user?.token ?? '',
          ));
    }
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
            'Products',
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
              child: (context.watch<ProductBloc>().state.apiRequestStatus ==
                      ApiRequestStatus.loading)
                  ? Wrap(
                      spacing: AppSize.smallSize,
                      runSpacing: AppSize.smallSize,
                      children: List.generate(
                        6,
                        (index) => const ProductShimmer(),
                      ),
                    )
                  : context.watch<ProductBloc>().state.products.isEmpty
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
                              .watch<ProductBloc>()
                              .state
                              .products
                              .map((e) => Product(
                                    product: e,
                                    showShop: true,
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
