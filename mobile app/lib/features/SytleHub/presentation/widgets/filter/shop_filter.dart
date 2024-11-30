import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import '../../../../../core/utils/captilizations.dart';
import '../../../../../setUp/language/translation_map.dart';
import '../../../../../setUp/size/app_size.dart';
import '../../../data/models/product/location_model.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/product_filter/product_filter_bloc.dart';
import '../../pages/filter/location.dart';
import 'display/common_filter_status_display.dart';
import 'display/location_filter_content.dart';

class ShopFilter extends StatefulWidget {
  const ShopFilter({
    super.key,
    required this.selectedCategories,
    required this.onSelectedCategory,
    required this.onSelectedRating,
    required this.selectedRating,
    required this.selectedVerified,
    required this.onSelectedVerified,
    required this.onClear,
    required this.onFilter,
  });

  final Set<String> selectedCategories;
  final Function(String) onSelectedCategory;
  final Function(double) onSelectedRating;
  final double? selectedRating;
  final String? selectedVerified;
  final Function(String) onSelectedVerified;
  final Function() onClear;
  final Function() onFilter;

  @override
  State<ShopFilter> createState() => _ShopFilterState();
}

class _ShopFilterState extends State<ShopFilter> {
  double? selectedRating;
  String? selectedVerified;

  @override
  void initState() {
    super.initState();
    selectedRating = widget.selectedRating;
    selectedVerified = widget.selectedVerified;
  }

  Widget bodyBuilder({required String text, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.smallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSize.xSmallSize),
          content,
        ],
      ),
    );
  }

  List<String> categories = [
    'men\'s fashion',
    'women\'s fashion',
    'kids fashion',
    'health & beauty',
    'sports & outdoors',
    'other'
  ];

  List<String> verified = [
    'verified',
    'not verified',
    'all',
  ];

  @override
  Widget build(BuildContext context) {
    String localizeVerified(String verified) {
      switch (verified) {
        case 'all':
          return AppLocalizations.of(context)!.all;
        case 'verified':
          return AppLocalizations.of(context)!.verified;
        case 'not verified':
          return AppLocalizations.of(context)!.not_verified;
        default:
          return '';
      }
    }

    String localizeCategory(int index) {
      switch (index) {
        case 0:
          return AppLocalizations.of(context)!.updateShopBasicInfo_mensFashion;
        case 1:
          return AppLocalizations.of(context)!
              .updateShopBasicInfo_womensFashion;
        case 2:
          return AppLocalizations.of(context)!.updateShopBasicInfo_kidsFashion;
        case 3:
          return AppLocalizations.of(context)!
              .updateShopBasicInfo_healthAndBeauty;
        case 4:
          return AppLocalizations.of(context)!
              .updateShopBasicInfo_sportsAndOutdoors;
        case 5:
          return AppLocalizations.of(context)!.updateShopBasicInfo_other;
        default:
          return '';
      }
    }

    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: AppSize.smallSize,
                    bottom: AppSize.xSmallSize,
                    right: AppSize.smallSize,
                    top: AppSize.xSmallSize),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.shop_filter,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSize.xxSmallSize),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSize.mediumSize),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bodyBuilder(
                          content: Wrap(
                            spacing: AppSize.smallSize,
                            runSpacing: AppSize.smallSize,
                            children: [
                              for (int index = 0;
                                  index < categories.length;
                                  index++)
                                widget.selectedCategories
                                        .contains(categories[index])
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            widget.selectedCategories
                                                .remove(categories[index]);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppSize.smallSize,
                                              vertical: AppSize.xxSmallSize),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xxSmallSize),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          child: Text(
                                            Captilizations.capitalize(
                                                localizeCategory(index)),
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
                                          setState(() {
                                            widget.selectedCategories
                                                .add(categories[index]);
                                          });
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: AppSize.smallSize,
                                                vertical: AppSize.xxSmallSize),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSize.xxSmallSize),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerHigh,
                                              ),
                                            ),
                                            child: Text(
                                              Captilizations.capitalize(
                                                  localizeCategory(index)),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                            )),
                                      ),
                            ],
                          ),
                          text:
                              '${AppLocalizations.of(context)!.categories} ${widget.selectedCategories.isNotEmpty ? '(${widget.selectedCategories.length})' : ''}',
                        ),
                        bodyBuilder(
                          content: RatingStars(
                            axis: Axis.horizontal,
                            value: selectedRating ?? 0.0,
                            starCount: 5,
                            starSize: 40,
                            onValueChanged: (value) {
                              setState(() {
                                selectedRating = value;
                                widget.onSelectedRating(value);
                              });
                            },
                            valueLabelColor: const Color(0xff9b9b9b),
                            valueLabelTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            valueLabelRadius: 10,
                            maxValue: 5,
                            starSpacing: 8,
                            maxValueVisibility: true,
                            valueLabelVisibility: false,
                            animationDuration:
                                const Duration(milliseconds: 1000),
                            valueLabelPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 8),
                            valueLabelMargin: const EdgeInsets.only(right: 8),
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: Colors.yellow,
                            angle: 12,
                          ),
                          text: AppLocalizations.of(context)!.rating,
                        ),
                        bodyBuilder(
                          content: Wrap(
                            spacing: AppSize.smallSize,
                            runSpacing: AppSize.smallSize,
                            children: [
                              for (int index = 0;
                                  index < verified.length;
                                  index++)
                                selectedVerified == verified[index]
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedVerified = '';
                                            widget.onSelectedVerified(
                                                verified[index]);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppSize.smallSize,
                                              vertical: AppSize.xxSmallSize),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xxSmallSize),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                          child: Text(
                                            Captilizations.capitalize(
                                                localizeVerified(
                                                    verified[index])),
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
                                          setState(() {
                                            selectedVerified = verified[index];
                                            widget.onSelectedVerified(
                                                verified[index]);
                                          });
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: AppSize.smallSize,
                                                vertical: AppSize.xxSmallSize),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSize.xxSmallSize),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerHigh,
                                              ),
                                            ),
                                            child: Text(
                                              Captilizations.capitalize(
                                                  localizeVerified(
                                                      verified[index])),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                            )),
                                      ),
                            ],
                          ),
                          text: AppLocalizations.of(context)!.shop_verified,
                        ),
                        CommonFilterStatusDisplay(
                          content: const LocationFilterContent(),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LocationFullFilterScreen()));
                          },
                          text:
                              '${AppLocalizations.of(context)!.filter_location} (${LocalizationMap.getLocationMap(context, (context.watch<ProductBloc>().state.locations.firstWhere((element) => element.id == context.watch<ProductFilterBloc>().state.location, orElse: () => const LocationModel(id: '', name: '-', latitude: 0.0, longitude: 0.0)).name))})',
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          height: 0.5,
        ),
        Padding(
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    widget.onClear();
                    setState(() {
                      selectedRating = 0.0;
                      selectedVerified = '';
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.filter_clear,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface))),
              GestureDetector(
                onTap: () {
                  widget.onFilter();
                  Navigator.pop(context, true);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.smallSize,
                      vertical: AppSize.xSmallSize),
                  margin: const EdgeInsets.only(right: AppSize.smallSize),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppSize.xxSmallSize),
                  ),
                  child: Text(AppLocalizations.of(context)!.filter_result,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
