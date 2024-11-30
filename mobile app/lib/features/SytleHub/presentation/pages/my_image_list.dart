import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/product/image_entity.dart';
import '../bloc/shop/shop_bloc.dart';
import '../widgets/common/show_image.dart';

class MyImageList extends StatefulWidget {
  const MyImageList(
      {super.key, required this.selectedImages, required this.shopId});

  final String shopId;
  final Set<ImageEntity> selectedImages;

  @override
  State<MyImageList> createState() => _MyImageListState();
}

class _MyImageListState extends State<MyImageList> {
  final Set<ImageEntity> selectedImages = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedImages.addAll(widget.selectedImages);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context
            .read<ShopBloc>()
            .add(GetShopProductsImagesEvent(shopId: widget.shopId));
      }
    });
  }

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

    final String shopId = context.read<ShopBloc>().state.myShopId ?? "";

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.smallSize),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, selectedImages),
                    child: Icon(
                      Icons.arrow_back_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.my_images,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(width: AppSize.xLargeSize),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSize.smallSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 2,
                      margin: const EdgeInsets.only(top: AppSize.xSmallSize),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const SizedBox(height: AppSize.smallSize),
                    Wrap(
                      spacing: AppSize.smallSize,
                      runSpacing: AppSize.smallSize,
                      children: context
                          .watch<ShopBloc>()
                          .state
                          .shops[shopId]!
                          .images
                          .values
                          .map(
                            (e) => GestureDetector(
                              onTap: () => _toggleSelection(e),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: width,
                                  maxHeight: width,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: ShowImage(image: e.imageUri)),
                                      if (selectedImages.contains(e))
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if (context
                            .watch<ShopBloc>()
                            .state
                            .shopProductImageStatus !=
                        ShopProductImageStatus.loadMore)
                      const SizedBox(height: AppSize.mediumSize),
                    if (context
                            .watch<ShopBloc>()
                            .state
                            .shopProductImageStatus ==
                        ShopProductImageStatus.loadMore)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.mediumSize),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            if (context.watch<ShopBloc>().state.shopProductImageStatus !=
                ShopProductImageStatus.loadMore)
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImages.clear();
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.clear_all,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (selectedImages.isNotEmpty) {
                              Navigator.pop(context, selectedImages);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                  title: Text(AppLocalizations.of(context)!
                                      .no_image_selected),
                                  children: [
                                    SimpleDialogOption(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                          AppLocalizations.of(context)!.ok),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.xSmallSize),
                            margin:
                                const EdgeInsets.only(right: AppSize.smallSize),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xxSmallSize),
                            ),
                            child: Text(
                              selectedImages.isNotEmpty
                                  ? AppLocalizations.of(context)!
                                      .add_image_count(
                                          "${selectedImages.length}")
                                  : AppLocalizations.of(context)!.add_image,
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
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  void _toggleSelection(ImageEntity imageUri) {
    setState(() {
      if (selectedImages.contains(imageUri)) {
        selectedImages.remove(imageUri);
      } else {
        selectedImages.add(imageUri);
      }
    });
  }
}
