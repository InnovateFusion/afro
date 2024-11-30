import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/language/translation_map.dart';
import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/product/category_entity.dart';
import '../../domain/entities/product/domain_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../bloc/general/general_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/scroll/scroll_bloc.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/app_bar_two.dart';
import '../widgets/common/button.dart';
import '../widgets/common/category_chip.dart';
import '../widgets/common/product.dart';
import '../widgets/shimmer/category_chip.dart';
import '../widgets/shimmer/product.dart';
import 'product_list.dart';
import 'product_search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.openCloseDrawer});

  final VoidCallback openCloseDrawer;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final List<String>? categoryIds =
        context.read<UserBloc>().state.user?.productCategoryPreferences;

    context.read<ShopBloc>().add(GetProductsEvent(
          token: context.read<UserBloc>().state.user?.token ?? '',
          categoryIds: categoryIds,
          homePageTabIndex: 0,
        ));
    _scrollController.addListener(_scrollListener);
  }

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;
  int tabIndex = 0;
  List<CategoryEntity> allCategories = [];
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emailVerificationController =
      TextEditingController();
  String? emailError;

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
      loadData();
    }
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    emailController.dispose();
    emailVerificationController.dispose();

    super.dispose();
  }

  List<CategoryEntity> listOfCategories(
      List<DomainEntity> domains, UserEntity? user) {
    Set<CategoryEntity> categories = {};
    for (int i = 0; i < domains.length; i++) {
      for (int j = 0; j < domains[i].subDomain.length; j++) {
        for (int k = 0; k < domains[i].subDomain[j].category.length; k++) {
          if (user?.dateOfBirth != null) {
            final DateTime dateOfBirth = user!.dateOfBirth!;
            final int age = DateTime.now().year - dateOfBirth.year;

            if (age < 14) {
              if (domains[i].name.toLowerCase() == 'kids') {
                categories.add(domains[i].subDomain[j].category[k]);
              }

              continue;
            }
          }

          if (user?.gender == 'male') {
            if (domains[i].name.toLowerCase() == 'men') {
              categories.add(domains[i].subDomain[j].category[k]);
            }
            continue;
          }
          if (user?.gender == 'female') {
            if (domains[i].name.toLowerCase() == 'women') {
              categories.add(domains[i].subDomain[j].category[k]);
            }
            continue;
          }
        }
      }
    }

    List<CategoryEntity> categoriesList = categories.toList();

    categoriesList.shuffle();
    return categoriesList;
  }

  void onChangeTab(int index) {
    setState(() {
      tabIndex = index;
    });
    loadData();
  }

  List<String> listOfCategoryIds(List<DomainEntity> domains, String key) {
    Set<String> categories = {};
    for (int i = 0; i < domains.length; i++) {
      for (int j = 0; j < domains[i].subDomain.length; j++) {
        for (int k = 0; k < domains[i].subDomain[j].category.length; k++) {
          if (domains[i].name.toLowerCase() == key.toLowerCase()) {
            categories.add(domains[i].subDomain[j].category[k].id);
          }
        }
      }
    }

    return categories.toList();
  }

  void loadData() {
    if (tabIndex == 0) {
      context.read<ShopBloc>().add(GetProductsEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
            categoryIds:
                context.read<UserBloc>().state.user?.productCategoryPreferences,
            homePageTabIndex: tabIndex,
            latitudes: context.read<UserBloc>().state.user?.latitude,
            longitudes: context.read<UserBloc>().state.user?.longitude,
            radiusInKilometers: 100,
          ));
    } else if (tabIndex == 1) {
      context.read<ShopBloc>().add(GetProductsEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
            categoryIds: listOfCategoryIds(
                context.read<ProductBloc>().state.domains, "men"),
            homePageTabIndex: tabIndex,
          ));
    } else if (tabIndex == 2) {
      context.read<ShopBloc>().add(GetProductsEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
            categoryIds: listOfCategoryIds(
                context.read<ProductBloc>().state.domains, "women"),
            homePageTabIndex: tabIndex,
          ));
    } else if (tabIndex == 3) {
      context.read<ShopBloc>().add(GetProductsEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
            categoryIds: listOfCategoryIds(
                context.read<ProductBloc>().state.domains, "shoes"),
            homePageTabIndex: tabIndex,
          ));
    } else if (tabIndex == 4) {
      context.read<ShopBloc>().add(GetProductsEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
            categoryIds: listOfCategoryIds(
                context.read<ProductBloc>().state.domains, "kids"),
            homePageTabIndex: tabIndex,
          ));
    } else if (tabIndex == 5) {
      context.read<ShopBloc>().add(GetFollowingShopProductsEvent(
            token: context.read<UserBloc>().state.user?.token ?? '',
            homePageTabIndex: tabIndex,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      Captilizations.capitalize(
          AppLocalizations.of(context)!.homeScreenCategoryForYou),
      Captilizations.capitalize(AppLocalizations.of(context)!.domain_men),
      Captilizations.capitalize(AppLocalizations.of(context)!.domain_women),
      Captilizations.capitalize(AppLocalizations.of(context)!.domain_shoes),
      Captilizations.capitalize(AppLocalizations.of(context)!.domain_kids),
      Captilizations.capitalize(
          AppLocalizations.of(context)!.homeScreenCategoryFollowingShops),
    ];
    double width = MediaQuery.of(context).size.width;

    int numbersDisplayed = 0;
    if (width <= 240) {
      numbersDisplayed = 4;
    } else if (width <= 340) {
      numbersDisplayed = 6;
    } else if (width <= 450) {
      numbersDisplayed = 12;
    } else if (width <= 550) {
      numbersDisplayed = 10;
    } else if (width <= 650) {
      numbersDisplayed = 12;
    } else if (width <= 750) {
      numbersDisplayed = 14;
    } else {
      numbersDisplayed = 20;
    }

    if (allCategories.isEmpty &&
        context.watch<ProductBloc>().state.domainStatus ==
            DomainStatus.success) {
      setState(() {
        allCategories = listOfCategories(
            context.watch<ProductBloc>().state.domains,
            context.watch<UserBloc>().state.user);
      });
    }

    return RefreshIndicator(
      onRefresh: () async {
        final List<String>? categoryIds =
            context.read<UserBloc>().state.user?.productCategoryPreferences;
        context.read<ProductBloc>().add(GetDomainsEvent());

        context.read<ShopBloc>().add(GetProductsEvent(
              token: context.read<UserBloc>().state.user?.token ?? '',
              categoryIds: categoryIds,
              homePageTabIndex: Random().nextInt(6),
            ));
      },
      child: BlocListener<GeneralBloc, GeneralState>(
        listener: (context, state) {
          if (state.sendVerificationEmailRequestStatus ==
              RequestVerificationEmailStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 3),
                content: Center(
                  child: Text(
                    AppLocalizations.of(context)!.verification_code_sent,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else if (state.verifyEmailStatus == EmailVerifyCodeStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 3),
                content: Center(
                  child: Text(
                    AppLocalizations.of(context)!.verifyCodeEmailVerified,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );
            context.read<GeneralBloc>().add(OnVerifyEmailSuccessEvent());
            context.read<UserBloc>().add(EmailVerifiedEvent(
                  email: emailController.text.trim(),
                ));
          } else if (state.sendVerificationEmailRequestStatus ==
                  RequestVerificationEmailStatus.failure ||
              state.verifyEmailStatus == EmailVerifyCodeStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(
                    state.errorMessage ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          }
        },
        child: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.only(
              left: AppSize.smallSize,
              right: AppSize.smallSize,
              top: AppSize.smallSize),
          child: Column(
            children: [
              AppBarTwo(
                onTap: widget.openCloseDrawer,
              ),
              const SizedBox(height: AppSize.smallSize),
              GestureDetector(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: '/productSearch'),
                    withNavBar: false,
                    screen: const ProductSearchPage(),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.smallSize,
                    vertical: AppSize.xSmallSize + 3,
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
                      Text(
                        AppLocalizations.of(context)!.homeScreenSearchHint,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              if (context.watch<UserBloc>().state.user?.isEmailVerified != true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.smallSize,
                    vertical: AppSize.xxSmallSize,
                  ),
                  margin: const EdgeInsets.only(top: AppSize.smallSize),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: AppSize.xSmallSize),
                            Expanded(
                              child: TextFormField(
                                controller: (context
                                                .watch<GeneralBloc>()
                                                .state
                                                .sendVerificationEmailRequestStatus !=
                                            RequestVerificationEmailStatus
                                                .success &&
                                        context
                                                .watch<GeneralBloc>()
                                                .state
                                                .sendVerificationEmailRequestStatus !=
                                            RequestVerificationEmailStatus.done)
                                    ? emailController
                                    : emailVerificationController,
                                validator: (String? value) {
                                  setState(() {
                                    emailError =
                                        (value == null || value.isEmpty)
                                            ? AppLocalizations.of(context)!
                                                .signInEmailCannotBeEmpty
                                            : null;
                                  });
                                  return emailError;
                                },
                                decoration: InputDecoration(
                                  hintText: (context
                                                  .watch<GeneralBloc>()
                                                  .state
                                                  .sendVerificationEmailRequestStatus ==
                                              RequestVerificationEmailStatus
                                                  .success ||
                                          context
                                                  .watch<GeneralBloc>()
                                                  .state
                                                  .sendVerificationEmailRequestStatus ==
                                              RequestVerificationEmailStatus
                                                  .done)
                                      ? AppLocalizations.of(context)!.enter_code
                                      : AppLocalizations.of(context)!
                                          .enter_email,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                  errorText: emailError,
                                  border: InputBorder.none,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if ((context
                                  .watch<GeneralBloc>()
                                  .state
                                  .sendVerificationEmailRequestStatus ==
                              RequestVerificationEmailStatus.loading ||
                          context
                                  .watch<GeneralBloc>()
                                  .state
                                  .verifyEmailStatus ==
                              EmailVerifyCodeStatus.loading))
                        const CircularProgressIndicator(
                          strokeWidth: 2,
                        )
                      else
                        GestureDetector(
                          onTap: () {
                            if (context
                                        .read<GeneralBloc>()
                                        .state
                                        .sendVerificationEmailRequestStatus !=
                                    RequestVerificationEmailStatus.success &&
                                context
                                        .read<GeneralBloc>()
                                        .state
                                        .sendVerificationEmailRequestStatus !=
                                    RequestVerificationEmailStatus.done) {
                              context.read<GeneralBloc>().add(
                                  VerifyEmailRequestEvent(
                                      token: context
                                              .read<UserBloc>()
                                              .state
                                              .user
                                              ?.token ??
                                          "",
                                      email: emailController.text.trim()));
                            } else {
                              context.read<GeneralBloc>().add(
                                  VerifyEmailCodeEvent(
                                      email: emailController.text.trim(),
                                      code: emailVerificationController.text
                                          .trim(),
                                      token: context
                                              .read<UserBloc>()
                                              .state
                                              .user
                                              ?.token ??
                                          ""));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.xSmallSize,
                              vertical: AppSize.xxSmallSize,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xxSmallSize),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.verify,
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
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSize.smallSize),
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .homeScreenExploreTitle,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSize.smallSize),
                          if (width < 700)
                            if (context
                                    .watch<ProductBloc>()
                                    .state
                                    .domainStatus ==
                                DomainStatus.loading)
                              Wrap(
                                spacing: AppSize.smallSize,
                                runSpacing: AppSize.smallSize,
                                children: List.generate(
                                  numbersDisplayed,
                                  (index) => const CategoryChipShimmer(),
                                ),
                              )
                            else
                              Wrap(
                                  spacing: AppSize.smallSize,
                                  runSpacing: AppSize.smallSize,
                                  children: allCategories
                                      .sublist(
                                          0,
                                          min(allCategories.length,
                                              numbersDisplayed))
                                      .map((e) => CategoryChip(
                                            name:
                                                LocalizationMap.getCategoryMap(
                                                    context,
                                                    e.name.toLowerCase()),
                                            image: e.image,
                                            isSelected: false,
                                            onTap: () {
                                              final passCategories = [e];
                                              for (var cat in allCategories) {
                                                if (cat != e) {
                                                  passCategories.add(cat);
                                                }
                                              }

                                              PersistentNavBarNavigator
                                                  .pushNewScreenWithRouteSettings(
                                                context,
                                                settings: const RouteSettings(
                                                    name: '/productList'),
                                                withNavBar: false,
                                                screen: ProductList(
                                                    categories: passCategories),
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .fade,
                                              );
                                            },
                                          ))
                                      .toList()),
                          if (width >= 700)
                            if (context
                                    .watch<ProductBloc>()
                                    .state
                                    .domainStatus ==
                                DomainStatus.loading)
                              Wrap(
                                spacing: AppSize.smallSize,
                                runSpacing: AppSize.smallSize,
                                children: List.generate(
                                  numbersDisplayed,
                                  (index) => const CategoryChipShimmer(),
                                ),
                              )
                            else
                              SizedBox(
                                height: 108,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allCategories.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: CategoryChip(
                                          name: LocalizationMap.getCategoryMap(
                                              context,
                                              allCategories[index]
                                                  .name
                                                  .toLowerCase()),
                                          image: allCategories[index].image,
                                          isSelected: false,
                                          onTap: () {
                                            final passCategories = [
                                              allCategories[index]
                                            ];

                                            for (int i = 0;
                                                i < allCategories.length;
                                                i++) {
                                              if (i != index) {
                                                passCategories
                                                    .add(allCategories[i]);
                                              }
                                            }

                                            PersistentNavBarNavigator
                                                .pushNewScreenWithRouteSettings(
                                              context,
                                              settings: const RouteSettings(
                                                  name: '/productList'),
                                              withNavBar: false,
                                              screen: ProductList(
                                                  categories: passCategories),
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation.fade,
                                            );
                                          }),
                                    );
                                  },
                                ),
                              ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: AppSize.mediumSize)),
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      forceMaterialTransparency: true,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      toolbarHeight: 55,
                      flexibleSpace: Container(
                        color: Theme.of(context).colorScheme.onPrimary,
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.only(bottom: AppSize.smallSize),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return ChipButton(
                              text: categories[index],
                              onTap: () {
                                onChangeTab(index);
                              },
                              isActive: tabIndex == index,
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: (context
                                      .watch<ShopBloc>()
                                      .state
                                      .mainProductStatus ==
                                  MainProductsStatus.loading ||
                              context
                                      .watch<ShopBloc>()
                                      .state
                                      .mainProductStatus ==
                                  MainProductsStatus.initial)
                          ? Wrap(
                              spacing: AppSize.smallSize,
                              runSpacing: AppSize.smallSize,
                              children: List.generate(
                                6,
                                (index) => const ProductShimmer(),
                              ),
                            )
                          : context
                                  .watch<ShopBloc>()
                                  .state
                                  .products
                                  .values
                                  .isEmpty
                              ? Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(AppSize.smallSize),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/Screens/no_data.png',
                                          width: 300,
                                          height: 300,
                                        ),
                                        const SizedBox(
                                            height: AppSize.xSmallSize),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .noProductsFound,
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
                                      .products
                                      .values
                                      .where(
                                          (e) => e.productApprovalStatus == 2)
                                      .map((e) => Product(
                                            product: e,
                                            showShop: true,
                                          ))
                                      .toList(),
                                ),
                    ),
                    if (context.watch<ShopBloc>().state.mainProductStatus ==
                        MainProductsStatus.loadMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.smallSize),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
