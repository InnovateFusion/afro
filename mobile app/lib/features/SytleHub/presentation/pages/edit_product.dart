import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../setUp/size/app_size.dart';
import '../../domain/entities/product/image_entity.dart';
import '../../domain/entities/product/product_entity.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product_filter/product_filter_bloc.dart';
import '../bloc/shop/shop_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../widgets/common/custom_input_field_product.dart';
import '../widgets/filter/half_brand_filter.dart';
import '../widgets/filter/half_color_filter.dart';
import '../widgets/filter/half_design_filter.dart';
import '../widgets/filter/half_material_filter.dart';
import '../widgets/filter/half_size_filter.dart';
import '../widgets/my_shop/category_select.dart';
import 'filter/brand.dart';
import 'filter/color.dart';
import 'filter/design.dart';
import 'filter/material.dart';
import 'filter/size.dart';
import 'my_image_list.dart';

enum Filters { color, material, size, brand, price, location, design, all }

enum OnSummit { publish, draft }

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController videoUrl = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.product.title;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    videoUrl.text = widget.product.videoUrl ?? '';
    isNegotiable = widget.product.isNegotiable;
    inStock = widget.product.inStock;
    isDeliverable = widget.product.isDeliverable;
    isNew = widget.product.isNew;
    quantityController.text = widget.product.availableQuantity.toString();
    _imageEntities.addAll(widget.product.images);
    context.read<ProductFilterBloc>().add(ClearAllEvent());
    context.read<ProductFilterBloc>().add(AddMultipleSelectedCategoriesEvent(
        widget.product.categories.map((e) => e.id).toList()));
    context.read<ProductFilterBloc>().add(AddMultipleSelectedColorsEvent(
        widget.product.colors.map((e) => e.id).toList()));
    context.read<ProductFilterBloc>().add(AddMultipleSelectedMaterialsEvent(
        widget.product.materials.map((e) => e.id).toList()));
    context.read<ProductFilterBloc>().add(AddMultipleSelectedSizesEvent(
        widget.product.sizes.map((e) => e.id).toList()));
    context.read<ProductFilterBloc>().add(AddMultipleSelectedBrandsEvent(
        widget.product.brands.map((e) => e.id).toList()));
    context.read<ProductFilterBloc>().add(AddMultipleSelectedDesignsEvent(
        widget.product.designs.map((e) => e.id).toList()));
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    videoUrl.dispose();
    quantityController.dispose();
    super.dispose();
  }

  bool isNegotiable = false;
  bool inStock = true;
  bool isDeliverable = false;
  bool isNew = true;

  String titleError = '';
  String descriptionError = '';
  String priceError = '';
  String quantityError = '';
  String videoUrlError = '';

  final List<XFile> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  final Set<ImageEntity> _imageEntities = {};

  void validateTitle(String value) {
    if (value.isEmpty) {
      setState(() {
        titleError =
            AppLocalizations.of(context)!.addProductScreenTitleRequired;
      });
    } else {
      setState(() {
        titleError = '';
      });
    }
  }

  void validateDescription(String value) {
    if (value.isEmpty) {
      setState(() {
        descriptionError =
            AppLocalizations.of(context)!.addProductScreenDescriptionRequired;
      });
    } else {
      setState(() {
        descriptionError = '';
      });
    }
  }

  void validatePrice(String value) {
    if (value.isEmpty) {
      setState(() {
        priceError =
            AppLocalizations.of(context)!.addProductScreenPriceRequired;
      });
    } else {
      final price = double.tryParse(value);
      if (price == null) {
        setState(() {
          priceError =
              AppLocalizations.of(context)!.addProductScreenInvalidPriceFormat;
        });
      } else if (price <= 0) {
        setState(() {
          priceError = AppLocalizations.of(context)!
              .addProductScreenPriceGreaterThanZero;
        });
      } else {
        setState(() {
          priceError = '';
        });
      }
    }
  }

  void validateQuantity(String value) {
    if (value.isEmpty) {
      setState(() {
        quantityError =
            AppLocalizations.of(context)!.addProductScreenQuantityRequired;
      });
    } else {
      final temp = double.tryParse(value);
      if (temp == null) {
        setState(() {
          quantityError =
              AppLocalizations.of(context)!.addProductScreenInvalidPriceFormat;
        });
      } else if (temp <= 0) {
        setState(() {
          quantityError = AppLocalizations.of(context)!
              .addProductScreenPriceGreaterThanZero;
        });
      } else {
        setState(() {
          quantityError = '';
        });
      }
    }
  }

  void validateVideoUrl(String value) {
    if (value.isNotEmpty) {
      if (!value.contains('https://www.youtube.com/watch?v=')) {
        setState(() {
          videoUrlError =
              AppLocalizations.of(context)!.addProductScreenVideoUrlNotValid;
        });
      } else {
        setState(() {
          videoUrlError = '';
        });
      }
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        final croppedFile = await _cropImage(pickedFile);
        if (croppedFile != null) {
          setState(() {
            _imageFiles.add(croppedFile);
          });
        }
      }
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile);
      if (croppedFile != null) {
        setState(() {
          _imageFiles.add(croppedFile);
        });
      }
    }
  }

  void displayBottomSheet(BuildContext context, Filters filterType) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.xxxSmallSize),
          topRight: Radius.circular(AppSize.xxxSmallSize),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) async {
            if (details.delta.dy < -5) {
              final data = await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      filterType == Filters.color
                          ? const ColorFullFilterScreen(isAdd: true)
                          : filterType == Filters.material
                              ? const MaterialFullFilterScreen(isAdd: true)
                              : filterType == Filters.size
                                  ? const SizeFullFilterScreen(isAdd: true)
                                  : filterType == Filters.design
                                      ? const DesignFullFilterScreen(
                                          isAdd: true)
                                      : filterType == Filters.brand
                                          ? const BrandFullFilterScreen(
                                              isAdd: true)
                                          : const SizedBox(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
              if (data != null && data == true) {
                Navigator.pop(context);
              }
            }
            if (details.delta.dy > 5) {
              Navigator.pop(context);
            }
          },
          child: filterType == Filters.color
              ? HalfColorFilterDisplay(isAdd: true, onTap: () {})
              : filterType == Filters.material
                  ? HalfMaterialFilterDisplay(isAdd: true, onTap: () {})
                  : filterType == Filters.size
                      ? HalfSizeFilterDisplay(isAdd: true, onTap: () {})
                      : filterType == Filters.brand
                          ? HalfBrandFilterDisplay(isAdd: true, onTap: () {})
                          : filterType == Filters.design
                              ? HalfDesignFilterDisplay(
                                  isAdd: true,
                                  onTap: () {},
                                )
                              : const SizedBox(),
        );
      },
    );
  }

  Future<XFile?> _cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle:
              AppLocalizations.of(context)!.addProductScreenCropperToolbarTitle,
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
          ],
        ),
        IOSUiSettings(
          title:
              AppLocalizations.of(context)!.addProductScreenCropperToolbarTitle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
          ],
        ),
      ],
    );

    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void removeBackground(BuildContext context, File imageFile, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        insetPadding: const EdgeInsets.all(AppSize.smallSize),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(AppSize.mediumSize),
          ),
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.background_remover,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSize.xxxLargeSize),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.largeSize),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(AppSize.smallSize),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 0.5),
                ),
                child: (context
                            .watch<ProductBloc>()
                            .state
                            .backgroundRemoveStatus ==
                        BackgroundRemoveStatus.loading)
                    ? Stack(
                        children: [
                          Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.8),
                              child: Center(
                                child: SpinKitFadingCircle(
                                  size: 240,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : context
                                .watch<ProductBloc>()
                                .state
                                .backgroundRemoveStatus ==
                            BackgroundRemoveStatus.success
                        ? Image.file(
                            context.watch<ProductBloc>().state.image!,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
              ),
              const SizedBox(height: AppSize.largeSize),
              context.watch<ProductBloc>().state.backgroundRemoveStatus ==
                      BackgroundRemoveStatus.success
                  ? GestureDetector(
                      onTap: () {
                        final image = context.read<ProductBloc>().state.image;
                        XFile xFile = XFile(image!.path);
                        setState(() {
                          _imageFiles[index] = xFile;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.smallSize),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              BorderRadius.circular(AppSize.xSmallSize),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.replace_original_image,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                    )
                  : (context
                                  .watch<ProductBloc>()
                                  .state
                                  .backgroundRemoveStatus ==
                              BackgroundRemoveStatus.initial ||
                          context
                                  .watch<ProductBloc>()
                                  .state
                                  .backgroundRemoveStatus ==
                              BackgroundRemoveStatus.failure)
                      ? GestureDetector(
                          onTap: () {
                            context.read<ProductBloc>().add(
                                  RemoveBackgroundEvent(
                                    image: imageFile,
                                    token: context
                                            .read<UserBloc>()
                                            .state
                                            .user
                                            ?.token ??
                                        "",
                                  ),
                                );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.smallSize),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xSmallSize),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.remove_background,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.smallSize),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xSmallSize),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.removing,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
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
      ),
    );
  }

  void removeBackgroundFromUrl(BuildContext context, ImageEntity imageEntity) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        insetPadding: const EdgeInsets.all(AppSize.smallSize),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(AppSize.mediumSize),
          ),
          padding: const EdgeInsets.all(AppSize.smallSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.background_remover,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSize.xxxLargeSize),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.largeSize),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(AppSize.smallSize),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      width: 0.5),
                ),
                child: (context
                            .watch<ProductBloc>()
                            .state
                            .backgroundRemoveStatus ==
                        BackgroundRemoveStatus.loading)
                    ? Stack(
                        children: [
                          Image.network(
                            imageEntity.imageUri,
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.8),
                              child: Center(
                                child: SpinKitFadingCircle(
                                  size: 240,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : context
                                .watch<ProductBloc>()
                                .state
                                .backgroundRemoveStatus ==
                            BackgroundRemoveStatus.success
                        ? Image.file(
                            context.watch<ProductBloc>().state.image!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imageEntity.imageUri,
                            fit: BoxFit.cover,
                          ),
              ),
              const SizedBox(height: AppSize.largeSize),
              context.watch<ProductBloc>().state.backgroundRemoveStatus ==
                      BackgroundRemoveStatus.success
                  ? GestureDetector(
                      onTap: () {
                        final image = context.read<ProductBloc>().state.image;
                        XFile xFile = XFile(image!.path);
                        setState(() {
                          _imageEntities.remove(imageEntity);
                          _imageFiles.add(xFile);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.smallSize,
                            vertical: AppSize.smallSize),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              BorderRadius.circular(AppSize.xSmallSize),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.replace_original_image,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                    )
                  : (context
                                  .watch<ProductBloc>()
                                  .state
                                  .backgroundRemoveStatus ==
                              BackgroundRemoveStatus.initial ||
                          context
                                  .watch<ProductBloc>()
                                  .state
                                  .backgroundRemoveStatus ==
                              BackgroundRemoveStatus.failure)
                      ? GestureDetector(
                          onTap: () {
                            context.read<ProductBloc>().add(
                                  RemoveBackgroundFromUrlEvent(
                                    imageUrl: imageEntity.imageUri,
                                    token: context
                                            .read<UserBloc>()
                                            .state
                                            .user
                                            ?.token ??
                                        "",
                                  ),
                                );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.smallSize),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xSmallSize),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.remove_background,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.smallSize,
                                vertical: AppSize.smallSize),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSize.xSmallSize),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.removing,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
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
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.xxxSmallSize),
          topRight: Radius.circular(AppSize.xxxSmallSize),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          AppLocalizations.of(context)!
                              .addProductScreenSelectImageSource,
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
              Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(
                        AppLocalizations.of(context)!.addProductScreenGallery),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImages();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text(
                        AppLocalizations.of(context)!.addProductScreenCamera),
                    onTap: () {
                      Navigator.of(context).pop();
                      _takePicture();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera_back),
                    title: Text(AppLocalizations.of(context)!
                        .addProductScreenExistingImages),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final Set<ImageEntity>? result =
                          await Navigator.of(context).push(
                        MaterialPageRoute<Set<ImageEntity>>(
                          builder: (context) => MyImageList(
                              selectedImages: _imageEntities,
                              shopId: widget.product.id),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _imageEntities.clear();
                          _imageEntities.addAll(result);
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
        const SizedBox(height: AppSize.xSmallSize),
        value,
      ],
    );
  }

  void onSubmitPress(OnSummit onSummitType) {
    validateTitle(titleController.text);
    // validateDescription(descriptionController.text);
    validatePrice(priceController.text);
    validateVideoUrl(videoUrl.text);
    validateQuantity(quantityController.text);

    if (context.read<ProductFilterBloc>().state.selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
                AppLocalizations.of(context)!.addProductScreenSelectCategory),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    if (_imageFiles.isEmpty && _imageEntities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
          child:
              Text(AppLocalizations.of(context)!.addProductScreenSelectImage),
        ),
      ));
      return;
    }

    if (titleError.isEmpty &&
        descriptionError.isEmpty &&
        priceError.isEmpty &&
        quantityError.isEmpty &&
        videoUrlError.isEmpty) {
      context.read<ShopBloc>().add(
            UpdateProductEvent(
              id: widget.product.id,
              title: titleController.text,
              description: descriptionController.text,
              price: double.parse(priceController.text).toInt(),
              videoUrl: videoUrl.text,
              inStock: inStock,
              availableQuantity: int.parse(quantityController.text),
              token: context.read<UserBloc>().state.user?.token ?? "",
              isNew: isNew,
              isNegotiable: isNegotiable,
              isDeliverable: isDeliverable,
              shopId: widget.product.shopInfo.id,
              fileImages: _imageFiles,
              status: onSummitType == OnSummit.publish ? 'active' : 'draft',
              images: _imageEntities.toList(),
              colorIds: context
                  .read<ProductFilterBloc>()
                  .state
                  .selectedColors
                  .toList(),
              sizeIds: context
                  .read<ProductFilterBloc>()
                  .state
                  .selectedSizes
                  .toList(),
              categoryIds: context
                  .read<ProductFilterBloc>()
                  .state
                  .selectedCategories
                  .toList(),
              brandIds: context
                  .read<ProductFilterBloc>()
                  .state
                  .selectedBrands
                  .toList(),
              materialIds: context
                  .read<ProductFilterBloc>()
                  .state
                  .selectedMaterials
                  .toList(),
              designIds: context
                  .read<ProductFilterBloc>()
                  .state
                  .selectedDesigns
                  .toList(),
            ),
          );
    }
  }

  void onClear() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    videoUrl.clear();
    quantityController.clear();
    titleError = '';
    descriptionError = '';
    priceError = '';
    videoUrlError = '';
    quantityError = '';
    isNew = true;
    isDeliverable = false;
    isNegotiable = false;
    inStock = true;

    _imageFiles.clear();
    _imageEntities.clear();
    context.read<ProductFilterBloc>().add(ClearAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: BlocListener<ShopBloc, ShopState>(
          listener: (context, state) {
            if (state.updateProductStatus == UpdateProductStatus.success ||
                state.updateProductStatus == UpdateProductStatus.loaded) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: Stack(
            children: [
              Column(
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
                          AppLocalizations.of(context)!.editProduct,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        PopupMenuButton<String>(
                            surfaceTintColor:
                                Theme.of(context).colorScheme.onPrimary,
                            color: Theme.of(context).colorScheme.onPrimary,
                            shadowColor:
                                Theme.of(context).colorScheme.onPrimary,
                            itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    onTap: onClear,
                                    child: Row(
                                      children: [
                                        Icon(Icons.clear,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        const SizedBox(
                                            width: AppSize.xSmallSize),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .addProductScreenClearAll, // Localize
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)),
                                      ],
                                    ),
                                  ),
                                ]),
                      ],
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppSize.smallSize),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                builderDetails(
                                  "${AppLocalizations.of(context)!.addProductScreenTitle} *",
                                  CustomInputFieldProduct(
                                    controller: titleController,
                                    hintText: AppLocalizations.of(context)!
                                        .addProductScreenTitleHint,
                                    errorText: titleError,
                                    onChanged: validateTitle,
                                    maxLines: 1,
                                  ),
                                ),
                                builderDetails(
                                  AppLocalizations.of(context)!
                                      .addProductScreenDescription,
                                  CustomInputFieldProduct(
                                    controller: descriptionController,
                                    hintText: AppLocalizations.of(context)!
                                        .addProductScreenDescriptionHint,
                                    errorText: descriptionError,
                                    maxLines: 4,
                                  ),
                                ),
                                builderDetails(
                                  "${AppLocalizations.of(context)!.addProductScreenCategories} ${context.watch<ProductFilterBloc>().state.selectedCategories.isEmpty ? '*' : '(${context.watch<ProductFilterBloc>().state.selectedCategories.length})'}",
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreenWithRouteSettings(
                                            context,
                                            settings: const RouteSettings(
                                                name: '/product/detail'),
                                            withNavBar: false,
                                            screen: const CategorySelection(),
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.smallSize,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xSmallSize),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.category,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              const SizedBox(
                                                  width: AppSize.xSmallSize),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .addProductScreenSelectCategories,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSize.mediumSize),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: builderDetails(
                                        "${AppLocalizations.of(context)!.addProductScreenPrice} *",
                                        CustomInputFieldProduct(
                                          controller: priceController,
                                          hintText: AppLocalizations.of(
                                                  context)!
                                              .addProductScreenSetPriceAmount,
                                          onChanged: validatePrice,
                                          errorText: priceError,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSize.smallSize),
                                    Expanded(
                                      child: builderDetails(
                                        AppLocalizations.of(context)!
                                            .quantity, // Localized "Quantity"
                                        CustomInputFieldProduct(
                                          controller: quantityController,
                                          hintText: AppLocalizations.of(
                                                  context)!
                                              .setQuantity, // Localized "Set quantity"
                                          onChanged: validateQuantity,
                                          errorText: quantityError,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                builderDetails(
                                  "${AppLocalizations.of(context)!.addProductScreenUploadImages} *",
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _showImageSourceActionSheet(
                                                context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.smallSize,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xSmallSize),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.upload,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              const SizedBox(
                                                  width: AppSize.xSmallSize),
                                              Text(
                                                  AppLocalizations.of(context)!
                                                      .addProductScreenUploadImagesButton,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: AppSize.smallSize),
                                      _imageFiles.isNotEmpty ||
                                              _imageEntities.isNotEmpty
                                          ? GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                crossAxisSpacing:
                                                    AppSize.xSmallSize,
                                                mainAxisSpacing:
                                                    AppSize.xSmallSize,
                                              ),
                                              itemCount: _imageFiles.length +
                                                  _imageEntities.length,
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    _imageFiles.length) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      context
                                                          .read<ProductBloc>()
                                                          .add(
                                                              ResetBackgroundRemoverEvent());
                                                      final image =
                                                          _imageFiles[index];

                                                      final imageFile =
                                                          File(image.path);
                                                      removeBackground(context,
                                                          imageFile, index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer,
                                                        borderRadius: BorderRadius
                                                            .circular(AppSize
                                                                .xSmallSize),
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primaryContainer,
                                                            width: 0.5),
                                                      ),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: Stack(
                                                        children: [
                                                          Image.file(
                                                            File(_imageFiles[
                                                                    index]
                                                                .path),
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                          ),
                                                          Positioned(
                                                            top: -4,
                                                            right: -4,
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.cancel,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () =>
                                                                  _removeImage(
                                                                      index),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  if (_imageEntities
                                                      .isNotEmpty) {
                                                    final image = _imageEntities
                                                        .elementAt(index -
                                                            _imageFiles.length);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<ProductBloc>()
                                                            .add(
                                                                ResetBackgroundRemoverEvent());
                                                        removeBackgroundFromUrl(
                                                            context, image);
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onPrimaryContainer,
                                                          borderRadius: BorderRadius
                                                              .circular(AppSize
                                                                  .xSmallSize),
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primaryContainer,
                                                              width: 0.5),
                                                        ),
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        child: Stack(
                                                          children: [
                                                            Image.network(
                                                              _imageEntities
                                                                  .elementAt(index -
                                                                      _imageFiles
                                                                          .length)
                                                                  .imageUri,
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .low,
                                                            ),
                                                            Positioned(
                                                              top: -4,
                                                              right: -4,
                                                              child: IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _imageEntities
                                                                        .remove(
                                                                            image);
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }

                                                return const SizedBox.shrink();
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),

                                if (_imageFiles.length + _imageEntities.length >
                                    0)
                                  Column(
                                    children: [
                                      const SizedBox(height: AppSize.smallSize),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          const SizedBox(
                                              width: AppSize.xSmallSize),
                                          Flexible(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .tap_to_remove_background,
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    height: 1.2,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                const SizedBox(height: AppSize.mediumSize),
                                builderDetails(
                                  AppLocalizations.of(context)!.status,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSize.xxSmallSize,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(
                                          AppSize.xSmallSize),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: AppSize.smallSize,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Checkbox(
                                                  value: isNegotiable,
                                                  checkColor: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isNegotiable = value!;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .negotiable,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Checkbox(
                                                  value: inStock,
                                                  checkColor: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      inStock = value!;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .inStock,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: isNew,
                                                  checkColor: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isNew = value!;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .isNew,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: isDeliverable,
                                                  checkColor: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isDeliverable = value!;
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .deliverable,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // builderDetails(
                                //   "${AppLocalizations.of(context)!.addProductScreenBrand} ${context.watch<ProductFilterBloc>().state.selectedBrands.isEmpty ? '' : '(${context.watch<ProductFilterBloc>().state.selectedBrands.length})'}",
                                //   Column(
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {
                                //           displayBottomSheet(
                                //               context, Filters.brand);
                                //         },
                                //         child: Container(
                                //           padding: const EdgeInsets.symmetric(
                                //             horizontal: AppSize.smallSize,
                                //             vertical: AppSize.smallSize,
                                //           ),
                                //           decoration: BoxDecoration(
                                //             color: Theme.of(context)
                                //                 .colorScheme
                                //                 .primaryContainer,
                                //             borderRadius: BorderRadius.circular(
                                //                 AppSize.xSmallSize),
                                //           ),
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.branding_watermark,
                                //                   color: Theme.of(context)
                                //                       .colorScheme
                                //                       .secondary),
                                //               const SizedBox(
                                //                   width: AppSize.xSmallSize),
                                //               Text(
                                //                 AppLocalizations.of(context)!
                                //                     .addProductScreenSelectBrand,
                                //                 style: Theme.of(context)
                                //                     .textTheme
                                //                     .titleMedium!
                                //                     .copyWith(
                                //                       color: Theme.of(context)
                                //                           .colorScheme
                                //                           .secondary,
                                //                     ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                const SizedBox(height: AppSize.mediumSize),
                                builderDetails(
                                  "${AppLocalizations.of(context)!.addProductScreenColors} ${context.watch<ProductFilterBloc>().state.selectedColors.isEmpty ? '' : '(${context.watch<ProductFilterBloc>().state.selectedColors.length})'}",
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          displayBottomSheet(
                                              context, Filters.color);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.smallSize,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xSmallSize),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.color_lens,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              const SizedBox(
                                                  width: AppSize.xSmallSize),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .addProductScreenSelectColor,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSize.mediumSize),
                                // builderDetails(
                                //   "${AppLocalizations.of(context)!.addProductScreenDesigns} ${context.watch<ProductFilterBloc>().state.selectedDesigns.isEmpty ? '' : '(${context.watch<ProductFilterBloc>().state.selectedDesigns.length})'}",
                                //   Column(
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {
                                //           displayBottomSheet(
                                //               context, Filters.design);
                                //         },
                                //         child: Container(
                                //           padding: const EdgeInsets.symmetric(
                                //             horizontal: AppSize.smallSize,
                                //             vertical: AppSize.smallSize,
                                //           ),
                                //           decoration: BoxDecoration(
                                //             color: Theme.of(context)
                                //                 .colorScheme
                                //                 .primaryContainer,
                                //             borderRadius: BorderRadius.circular(
                                //                 AppSize.xSmallSize),
                                //           ),
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.design_services,
                                //                   color: Theme.of(context)
                                //                       .colorScheme
                                //                       .secondary),
                                //               const SizedBox(
                                //                   width: AppSize.xSmallSize),
                                //               Text(
                                //                 AppLocalizations.of(context)!
                                //                     .addProductScreenSelectDesign,
                                //                 style: Theme.of(context)
                                //                     .textTheme
                                //                     .titleMedium!
                                //                     .copyWith(
                                //                       color: Theme.of(context)
                                //                           .colorScheme
                                //                           .secondary,
                                //                     ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(height: AppSize.mediumSize),
                                // builderDetails(
                                //   "${AppLocalizations.of(context)!.addProductScreenMaterials} ${context.watch<ProductFilterBloc>().state.selectedMaterials.isEmpty ? '' : '(${context.watch<ProductFilterBloc>().state.selectedMaterials.length})'}",
                                //   Column(
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {
                                //           displayBottomSheet(
                                //               context, Filters.material);
                                //         },
                                //         child: Container(
                                //           padding: const EdgeInsets.symmetric(
                                //             horizontal: AppSize.smallSize,
                                //             vertical: AppSize.smallSize,
                                //           ),
                                //           decoration: BoxDecoration(
                                //             color: Theme.of(context)
                                //                 .colorScheme
                                //                 .primaryContainer,
                                //             borderRadius: BorderRadius.circular(
                                //                 AppSize.xSmallSize),
                                //           ),
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.texture,
                                //                   color: Theme.of(context)
                                //                       .colorScheme
                                //                       .secondary),
                                //               const SizedBox(
                                //                   width: AppSize.xSmallSize),
                                //               Text(
                                //                 AppLocalizations.of(context)!
                                //                     .addProductScreenSelectMaterials,
                                //                 style: Theme.of(context)
                                //                     .textTheme
                                //                     .titleMedium!
                                //                     .copyWith(
                                //                       color: Theme.of(context)
                                //                           .colorScheme
                                //                           .secondary,
                                //                     ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(height: AppSize.mediumSize),

                                builderDetails(
                                  "${AppLocalizations.of(context)!.addProductScreenSizes} ${context.watch<ProductFilterBloc>().state.selectedSizes.isEmpty ? '' : '(${context.watch<ProductFilterBloc>().state.selectedSizes.length})'}",
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          displayBottomSheet(
                                              context, Filters.size);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.smallSize,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                                AppSize.xSmallSize),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.crop_3_2_outlined,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                              const SizedBox(
                                                  width: AppSize.xSmallSize),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .addProductScreenSelectSizes,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSize.smallSize),
                              ],
                            ),
                          ),
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        onSubmitPress(OnSummit.draft);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.xSmallSize),
                                        margin: const EdgeInsets.only(
                                            right: AppSize.smallSize),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          borderRadius: BorderRadius.circular(
                                              AppSize.xxSmallSize),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .addProductScreenDraft,
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
                                    ),
                                    const SizedBox(width: AppSize.xSmallSize),
                                    GestureDetector(
                                      onTap: () {
                                        onSubmitPress(OnSummit.publish);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSize.smallSize,
                                            vertical: AppSize.xSmallSize),
                                        margin: const EdgeInsets.only(
                                            right: AppSize.smallSize),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius: BorderRadius.circular(
                                              AppSize.xxSmallSize),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .addProductScreenPublish,
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
                  ),
                ],
              ),
              if (context.read<ShopBloc>().state.updateProductStatus ==
                  UpdateProductStatus.loading)
                Container(
                  color: Theme.of(context).colorScheme.scrim.withOpacity(0.95),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: SpinKitCircle(
                        size: 200,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(300),
                              color: index.isEven
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                            ),
                          );
                        },
                      )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
