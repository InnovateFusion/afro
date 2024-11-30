import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../setUp/size/app_size.dart';
import '../../bloc/shop/shop_bloc.dart';
import '../common/show_image.dart';
import '../shimmer/image.dart';

class ShopProductImages extends StatefulWidget {
  const ShopProductImages(
      {super.key, required this.shopId, this.myShop = false});
  final String shopId;
  final bool myShop;

  @override
  State<ShopProductImages> createState() => _ShopProductImagesState();
}

class _ShopProductImagesState extends State<ShopProductImages> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 340) {
    } else if (width <= 500) {
      width = (width - (16 * 3)) / 2;
    } else if (width <= 700) {
      width = (width - (16 * 4)) / 3;
    } else if (width <= 900) {
      width = (width - (16 * 5)) / 4;
    } else if (width <= 1100) {
      width = (width - (16 * 6)) / 5;
    } else if (width <= 1100) {
      width = (width - (16 * 7)) / 6;
    } else if (width <= 1400) {
      width = (width - (16 * 8)) / 7;
    } else {
      width = (width - (16 * 9)) / 8;
    }

    void showFullSizeImage(BuildContext context, String imageUri) {
      showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(AppSize.smallSize),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.smallSize),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.smallSize),
                      child: Image.network(imageUri),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 30,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (context.watch<ShopBloc>().state.shopProductImageStatus ==
        ShopProductImageStatus.loading) {
      return Wrap(
        spacing: AppSize.smallSize,
        runSpacing: AppSize.smallSize,
        children: List.generate(
          6,
          (index) => const ImageShimmer(),
        ),
      );
    }

    if (context.watch<ShopBloc>().state.shops[widget.shopId]!.images.isEmpty ||
        context
            .watch<ShopBloc>()
            .state
            .shops[widget.shopId]!
            .products
            .isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Column(
            children: [
              if (widget.myShop)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              Image.asset(
                'assets/images/Screens/no_photo.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: AppSize.xSmallSize),
              Text(
                AppLocalizations.of(context)!.noImagesFound,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: AppSize.smallSize,
      runSpacing: AppSize.smallSize,
      children: context
          .watch<ShopBloc>()
          .state
          .shops[widget.shopId]!
          .images
          .values
          .map(
            (e) => GestureDetector(
              onTap: () {
                showFullSizeImage(context, e.imageUri);
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width,
                  maxHeight: width,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(AppSize.xSmallSize),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 0.5,
                    ),
                  ),
                  child: ShowImage(image: e.imageUri),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
