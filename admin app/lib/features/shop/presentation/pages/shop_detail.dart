import 'package:afro_shop_admin/features/shop/domain/entities/shop_entity.dart';
import 'package:afro_shop_admin/setUp/shared_widgets/show_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/size/app_size.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({super.key, required this.shop});

  final ShopEntity shop;

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  int selectedTab = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget builderDetails(String title, Widget value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        value,
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.smallSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: 32,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 230,
                    child: Stack(
                      children: [
                        if (widget.shop.banner != null)
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: Image.network(
                              widget.shop.banner!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.photo,
                                    size: 90,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              },
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                  child: child,
                                );
                              },
                            ),
                          )
                        else
                          Container(
                            height: 180,
                            width: double.infinity,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        Positioned(
                          left: AppSize.smallSize,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(
                              widget.shop.logo,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Captilizations.capitalizeFirstOfEach(
                              widget.shop.name),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        Text(
                          widget.shop.subAdministrativeArea,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSize.mediumSize),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.xSmallSize),
                            decoration: BoxDecoration(
                              color: selectedTab == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xxSmallSize),
                            ),
                            child: Text(
                              'Documents',
                              textAlign: TextAlign.center,
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
                        const SizedBox(width: AppSize.smallSize),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.xSmallSize),
                            decoration: BoxDecoration(
                              color: selectedTab == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xxSmallSize),
                            ),
                            child: Text(
                              'Information',
                              textAlign: TextAlign.center,
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
                  if (selectedTab == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.smallSize),
                      height: 170,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          builderData(
                              context,
                              widget.shop.businessRegistrationDocumentUrl,
                              'Business License'),
                          builderData(context, widget.shop.ownerIdentityCardUrl,
                              'Owner ID'),
                          builderData(context, widget.shop.ownerSelfieUrl,
                              'Owner Selfie'),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.smallSize,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          builderDetails(
                            'Shop Details',
                            Text(
                              widget.shop.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ),
                          const SizedBox(height: AppSize.smallSize),
                          builderDetails(
                            'License Number',
                            Text(
                              widget.shop.businessRegistrationNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builderData(BuildContext context, String image, String value) {
    return GestureDetector(
      onTap: () => showFullSizeImage(context, image),
      child: Container(
        margin: const EdgeInsets.only(right: AppSize.smallSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 140,
              width: 140,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSize.xSmallSize),
              ),
              child: ShowImage(image: image),
            ),
            const SizedBox(height: AppSize.xxSmallSize),
            Text(
              Captilizations.capitalizeFirstOfEach(value),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
