import '../bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/captilizations.dart';
import '../../../../setUp/shared_widgets/show_image.dart';
import '../../../../setUp/size/app_size.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/shop_info_entity.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {super.key, required this.product, this.showShop = false});
  final ProductEntity product;
  final bool showShop;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget builderDetails(String title, Widget value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSize.xSmallSize),
          value,
        ],
      );
    }

    Future<void> makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }

    Future<void> shareContent(
        BuildContext context, ShopInfoEntity shopInfo) async {
      final uri = Uri(scheme: "google.navigation", queryParameters: {
        'q': '${shopInfo.latitude}, ${shopInfo.longitude}'
      });
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              content: Text(
                'Could not open Google Maps',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
        }();
      }
    }

    void changeIndex(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: SingleChildScrollView(
          child: Column(
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
                    if (widget.product.productApprovalStatus == 1 ||
                        widget.product.productApprovalStatus == 3)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.smallSize,
                          vertical: AppSize.xxSmallSize,
                        ),
                        decoration: BoxDecoration(
                          color: widget.product.productApprovalStatus == 1
                              ? Theme.of(context).colorScheme.tertiaryContainer
                              : Theme.of(context).colorScheme.error,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(AppSize.xxxLargeSize),
                          ),
                        ),
                        child: Text(
                          widget.product.productApprovalStatus == 1
                              ? "Pending"
                              : "Rejected",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      )
                  ],
                ),
              ),
              if (widget.product.images.isNotEmpty)
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null &&
                        details.primaryVelocity! > 0) {
                      if (selectedIndex > 0) {
                        changeIndex(selectedIndex - 1);
                      }
                    } else if (details.primaryVelocity != null &&
                        details.primaryVelocity! < 0) {
                      if (selectedIndex < widget.product.images.length - 1) {
                        changeIndex(selectedIndex + 1);
                      }
                    }
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        minHeight: 350),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          width: 0.65,
                        ),
                      ),
                      child: Stack(
                        children: [
                          ShowImage(
                              image: widget
                                  .product.images[selectedIndex].imageUri),
                          if (widget.product.createdAt.isAfter(
                              DateTime.now().subtract(const Duration(days: 7))))
                            Positioned(
                              top: 10,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.xSmallSize - 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  borderRadius: BorderRadius.circular(
                                      AppSize.xxSmallSize),
                                ),
                                child: Text(
                                  "New",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                            ),
                          if (widget.product.images.length > 1)
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int index = 0;
                                        index < widget.product.images.length;
                                        index++)
                                      GestureDetector(
                                        onTap: () {
                                          changeIndex(index);
                                        },
                                        child: Container(
                                          width:
                                              selectedIndex == index ? 32 : 24,
                                          height:
                                              selectedIndex == index ? 32 : 24,
                                          margin: const EdgeInsets.only(
                                              right: AppSize.smallSize),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            backgroundImage: NetworkImage(
                                              widget.product.images[index]
                                                  .imageUri,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(AppSize.smallSize),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: AppSize.xSmallSize,
                            runSpacing: AppSize.xSmallSize,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.smallSize - 4,
                                  vertical: AppSize.xxSmallSize - 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.xxxLargeSize),
                                  ),
                                ),
                                child: Text(
                                  timeago.format(widget.product.createdAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.smallSize - 4,
                                  vertical: AppSize.xxSmallSize - 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.xxxLargeSize),
                                  ),
                                ),
                                child: Text(
                                  widget.product.isNegotiable
                                      ? "Negotiable"
                                      : "Fixed",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                              if (widget.product.isDeliverable)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.smallSize - 4,
                                    vertical: AppSize.xxSmallSize - 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(AppSize.xxxLargeSize),
                                    ),
                                  ),
                                  child: Text(
                                    "Deliverable",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ),
                              if (widget.product.inStock)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.smallSize - 4,
                                    vertical: AppSize.xxSmallSize - 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(AppSize.xxxLargeSize),
                                    ),
                                  ),
                                  child: Text(
                                    "InStock",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSize.smallSize),
                          Text(
                            Captilizations.capitalizeFirstOfEach(
                                widget.product.title),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'ETB ${widget.product.price}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          Text(
                            '${widget.product.shopInfo.subLocality.isEmpty ? '' : '${widget.product.shopInfo.subLocality} | '}${widget.product.shopInfo.subAdministrativeArea}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.smallSize),
                      if (widget.product.description.isNotEmpty)
                        builderDetails(
                          "Description",
                          Text(
                            widget.product.description,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    height: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                        ),
                      const SizedBox(height: AppSize.smallSize),
                      if (widget.product.colors.isNotEmpty)
                        builderDetails(
                          "Color",
                          Wrap(
                            spacing: AppSize.mediumSize,
                            runSpacing: AppSize.smallSize,
                            children: [
                              for (int index = 0;
                                  index < widget.product.colors.length;
                                  index++)
                                Column(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          width: 0.75,
                                        ),
                                        color: Color(int.parse(
                                          "FF${widget.product.colors[index].hexCode.substring(1)}",
                                          radix: 16,
                                        )),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    const SizedBox(height: AppSize.xxSmallSize),
                                    Text(
                                      Captilizations.capitalize(
                                          widget.product.colors[index].name),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      if (widget.product.colors.isNotEmpty)
                        const SizedBox(height: AppSize.smallSize),
                      if (widget.product.sizes.isNotEmpty)
                        builderDetails(
                          "Size",
                          Wrap(
                            spacing: AppSize.mediumSize,
                            runSpacing: AppSize.smallSize,
                            children: [
                              for (int index = 0;
                                  index < widget.product.sizes.length;
                                  index++)
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.product.sizes[index].abbreviation
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (widget.product.sizes.isNotEmpty)
                        const SizedBox(height: AppSize.smallSize),
                      Container(
                        padding: const EdgeInsets.all(
                          AppSize.xSmallSize,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppSize.xSmallSize)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<ProductBloc>()
                                      .add(ProductApprovalEvent(
                                        token: context
                                                .read<AuthBloc>()
                                                .state
                                                .user
                                                ?.token ??
                                            '',
                                        id: widget.product.id,
                                        status: 2,
                                      ));
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.smallSize,
                                    vertical: AppSize.xSmallSize,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(AppSize.xSmallSize)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Approve",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSize.smallSize),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<ProductBloc>()
                                      .add(ProductApprovalEvent(
                                        token: context
                                                .read<AuthBloc>()
                                                .state
                                                .user
                                                ?.token ??
                                            '',
                                        id: widget.product.id,
                                        status: 3,
                                      ));

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.smallSize,
                                    vertical: AppSize.xSmallSize,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(AppSize.xSmallSize)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Decline",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
