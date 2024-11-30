import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../setUp/size/app_size.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/product.dart';
import '../widgets/shimmer/product.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ShopBloc>().add(GetFavoriteProductsEvent(
          token: context.read<UserBloc>().state.user?.token ?? ''));
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
                    AppLocalizations.of(context)!.favoriteScreenTitle,
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSize.smallSize),
                controller: _scrollController,
                child: context.watch<ShopBloc>().state.favoriteProductsStatus ==
                        FavoriteProductsStatus.loading
                    ? Wrap(
                        spacing: AppSize.smallSize,
                        runSpacing: AppSize.smallSize,
                        children: List.generate(
                          8,
                          (index) => const ProductShimmer(),
                        ),
                      )
                    : context
                            .watch<ShopBloc>()
                            .state
                            .favoriteProducts
                            .values
                            .where((e) => e.isFavorite)
                            .map((e) => Product(product: e))
                            .toList()
                            .isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                  ),
                                  Image.asset(
                                    'assets/images/Screens/no_data.png',
                                    width: 300,
                                    height: 300,
                                  ),
                                  const SizedBox(height: AppSize.xSmallSize),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .favoriteScreenNoFavorites,
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
                            ],
                          )
                        : Wrap(
                            spacing: AppSize.smallSize,
                            runSpacing: AppSize.smallSize,
                            children: context
                                .watch<ShopBloc>()
                                .state
                                .favoriteProducts
                                .values
                                .where((e) => e.isFavorite)
                                .map((e) => Product(product: e))
                                .toList(),
                          ),
              ),
            ),
            if (context.watch<ShopBloc>().state.favoriteProductsStatus ==
                FavoriteProductsStatus.loadMore)
              Padding(
                padding: const EdgeInsets.all(AppSize.smallSize),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
