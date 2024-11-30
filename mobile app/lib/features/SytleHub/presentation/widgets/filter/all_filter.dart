import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/product_filter/product_filter_bloc.dart';
import '../../pages/filter/color.dart';
import '../../pages/filter/location.dart';
import '../../pages/filter/size.dart';
import 'bottom_filter_bar.dart';
import 'display/color_filter_content.dart';
import 'display/common_filter_status_display.dart';
import 'display/location_filter_content.dart';
import 'display/size_filter_content.dart';
import 'other_filter.dart';
import 'price_filter.dart';
import 'sort_filter.dart';

class AllFilterDisplay extends StatelessWidget {
  const AllFilterDisplay({super.key, required this.isAdd, required this.onTap});

  final bool isAdd;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
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
                    AppLocalizations.of(context)!.filter_filter_sort,
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
                    borderRadius: BorderRadius.circular(AppSize.mediumSize),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
              child: (context.watch<ProductBloc>().state.brandStatus ==
                          BrandStatus.loading ||
                      context.watch<ProductBloc>().state.locationStatus ==
                          LocationStatus.loading ||
                      context.watch<ProductBloc>().state.materialStatus ==
                          MaterialStatus.loading ||
                      context.watch<ProductBloc>().state.sizeStatus ==
                          SizeStatus.loading ||
                      context.watch<ProductBloc>().state.colorStatus ==
                          ColorStatus.loading)
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4),
                      child: const Center(child: CircularProgressIndicator()))
                  : Column(
                      children: [
                        const SortFilterDisplay(),
                        const OtherFilterDisplay(),
                        // CommonFilterStatusDisplay(
                        //   content: const BrandFilterContent(),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const BrandFullFilterScreen()));
                        //   },
                        //   text:
                        //       '${AppLocalizations.of(context)!.filter_brand}${context.watch<ProductFilterBloc>().state.selectedBrands.isEmpty ? '' : ' (${context.watch<ProductFilterBloc>().state.selectedBrands.length})'}',
                        // ),
                        CommonFilterStatusDisplay(
                          content: const ColorFilterContent(),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ColorFullFilterScreen()));
                          },
                          text:
                              '${AppLocalizations.of(context)!.filter_color}${context.watch<ProductFilterBloc>().state.selectedColors.isEmpty ? '' : ' (${context.watch<ProductFilterBloc>().state.selectedColors.length})'}',
                        ),
                        // CommonFilterStatusDisplay(
                        //   content: const DesignFilterContent(),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const DesignFullFilterScreen()));
                        //   },
                        //   text:
                        //       '${AppLocalizations.of(context)!.filter_design}${context.watch<ProductFilterBloc>().state.selectedDesigns.isEmpty ? '' : ' (${context.watch<ProductFilterBloc>().state.selectedDesigns.length})'}',
                        // ),
                        CommonFilterStatusDisplay(
                          content: const LocationFilterContent(),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LocationFullFilterScreen()));
                          },
                          text: AppLocalizations.of(context)!.filter_location,
                        ),
                        // CommonFilterStatusDisplay(
                        //   content: const MaterialFilterContent(),
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const MaterialFullFilterScreen()));
                        //   },
                        //   text:
                        //       '${AppLocalizations.of(context)!.filter_material}${context.watch<ProductFilterBloc>().state.selectedMaterials.isEmpty ? '' : ' (${context.watch<ProductFilterBloc>().state.selectedMaterials.length})'}',
                        // ),
                        const PriceFilterDisplay(),
                        CommonFilterStatusDisplay(
                          content: const SizeFilterContent(),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SizeFullFilterScreen()));
                          },
                          text:
                              '${AppLocalizations.of(context)!.filter_size}${context.watch<ProductFilterBloc>().state.selectedSizes.isEmpty ? '' : ' (${context.watch<ProductFilterBloc>().state.selectedSizes.length})'}',
                        ),
                      ],
                    ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSize.smallSize),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: BottomFilterBar(
              isAdd: isAdd,
              onTapClear: () {
                context.read<ProductFilterBloc>().add(ClearAllEvent());
              },
              onTapResult: () {
                onTap();
                Navigator.pop(context, true);
              }),
        )
      ],
    );
  }
}
