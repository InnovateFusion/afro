import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/language/translation_map.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../../domain/entities/product/brand_entity.dart';
import '../../bloc/product_filter/product_filter_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../widgets/common/search.dart';
import '../../widgets/filter/bottom_filter_bar.dart';

class BrandFullFilterScreen extends StatefulWidget {
  const BrandFullFilterScreen({super.key, this.isAdd, this.onTap});

  final bool? isAdd;
  final Function()? onTap;

  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandFullFilterScreen> {
  bool _shouldPop = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<BrandEntity> filterBrand() {
      List<BrandEntity> brands = context.watch<ProductBloc>().state.brands;
      if (searchController.text.isEmpty) return brands;
      return brands
          .where((brand) => (LocalizationMap.getBrandMap(context, brand.name))
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    List<BrandEntity> brands = filterBrand();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification && !_shouldPop) {
              if (notification.metrics.pixels < -120) {
                setState(() {
                  _shouldPop = true;
                });
                Navigator.pop(context, true);
              }
            }
            return false;
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.smallSize,
                  vertical: AppSize.smallSize,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: Icon(
                        Icons.close_rounded,
                        size: 32,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: AppSize.smallSize),
                    Search(
                      title: AppLocalizations.of(context)!.filter_search_brand,
                      controller: searchController,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (context.watch<ProductBloc>().state.brandStatus ==
                        BrandStatus.loading)
                      const Expanded(
                          child: Center(child: CircularProgressIndicator())),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Wrap(spacing: AppSize.smallSize, children: [
                            if (context
                                    .watch<ProductBloc>()
                                    .state
                                    .brandStatus ==
                                BrandStatus.success)
                              for (int index = 0;
                                  index < brands.length;
                                  index++)
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: AppSize.smallSize),
                                  child: Column(
                                    children: [
                                      (context
                                              .watch<ProductFilterBloc>()
                                              .state
                                              .selectedBrands
                                              .contains(brands[index].id))
                                          ? GestureDetector(
                                              onTap: () {
                                                final brandId =
                                                    brands[index].id;
                                                context
                                                    .read<ProductFilterBloc>()
                                                    .add(
                                                        RemoveSelectedBrandEvent(
                                                            brandId));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                            AppSize.smallSize,
                                                        vertical: AppSize
                                                            .xxSmallSize),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppSize.xxSmallSize),
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                                ),
                                                child: Text(
                                                  Captilizations.capitalize(
                                                    LocalizationMap.getBrandMap(
                                                        context,
                                                        brands[index].name),
                                                  ),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                      ),
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                final brandId =
                                                    brands[index].id;
                                                context
                                                    .read<ProductFilterBloc>()
                                                    .add(AddSelectedBrandEvent(
                                                        brandId));
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                          AppSize.smallSize,
                                                      vertical:
                                                          AppSize.xxSmallSize),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppSize
                                                                .xxSmallSize),
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surfaceContainerHigh,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    Captilizations.capitalize(
                                                      LocalizationMap
                                                          .getBrandMap(
                                                              context,
                                                              brands[index]
                                                                  .name),
                                                    ),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                        ),
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                          ]),
                        ),
                      ),
                    ),
                    if (widget.onTap != null && widget.isAdd != null)
                      Container(
                        padding: const EdgeInsets.all(AppSize.smallSize),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: BottomFilterBar(
                            isAdd: widget.isAdd!,
                            onTapClear: () {
                              context
                                  .read<ProductFilterBloc>()
                                  .add(ClearSelectedBrandsEvent());
                            },
                            onTapResult: () {
                              widget.onTap!();
                              Navigator.pop(context, true);
                            }),
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
