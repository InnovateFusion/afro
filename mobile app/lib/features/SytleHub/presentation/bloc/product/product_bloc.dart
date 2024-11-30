import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_brand.dart'
    as brand_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_category.dart'
    as category_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_color.dart'
    as color_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_design.dart'
    as design_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_domain.dart'
    as domain_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_location.dart'
    as location_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_material.dart'
    as material_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_product.dart'
    as product_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_size.dart'
    as size_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/user/my_profile.dart'
    as my_profile;

import '../../../../../core/use_cases/usecase.dart';
import '../../../domain/entities/product/brand_entity.dart';
import '../../../domain/entities/product/category_entity.dart';
import '../../../domain/entities/product/color_entity.dart';
import '../../../domain/entities/product/design_entity.dart';
import '../../../domain/entities/product/domain_entity.dart';
import '../../../domain/entities/product/location_entity.dart';
import '../../../domain/entities/product/material_entity.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/entities/product/size_entity.dart';
import '../../../domain/usecases/product/background_remover.dart'
    as background_remover;
import '../../../domain/usecases/product/background_remover_from_url.dart'
    as background_remover_from_url;
import '../../../domain/usecases/product/share_product_to_tiktok.dart'
    as share_product_to_tiktok;

part 'product_event.dart';
part 'product_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final color_usecase.GetColorsUseCase getColorsUseCase;
  final brand_usecase.GetBrandsUseCase getBrandsUseCase;
  final material_usecase.GetMaterialsUseCase getMaterialsUseCase;
  final size_usecase.GetSizesUseCase getSizesUseCase;
  final category_usecase.GetCategoriesUseCase getCategoriesUseCase;
  final location_usecase.GetLocationUseCase getLocationUseCase;
  final design_usecase.GetDesignsUseCase getDesignsUseCase;
  final domain_usecase.GetDomainsUseCase getDomainsUseCase;
  final my_profile.MyProfileUsecase myProfileUseCase;
  final product_usecase.GetProductsUseCase getProductUseCase;
  final share_product_to_tiktok.ShareProductToTiktokUseCase
      shareProductToTiktokUseCase;
  final background_remover.BackgroundRemoverUseCase backgroundRemoverUseCase;
  final background_remover_from_url.BackgroundRemoverFromUrlUseCase
      backgroundRemoverFromUrlUseCase;

  ProductBloc({
    required this.getColorsUseCase,
    required this.getBrandsUseCase,
    required this.getMaterialsUseCase,
    required this.getSizesUseCase,
    required this.getCategoriesUseCase,
    required this.getLocationUseCase,
    required this.getDesignsUseCase,
    required this.getDomainsUseCase,
    required this.myProfileUseCase,
    required this.getProductUseCase,
    required this.shareProductToTiktokUseCase,
    required this.backgroundRemoverUseCase,
    required this.backgroundRemoverFromUrlUseCase,
  }) : super(const ProductState()) {
    on<GetColorsEvent>(_onGetColors,
        transformer: throttleDroppable(throttleDuration));

    on<GetBrandsEvent>(_onGetBrands,
        transformer: throttleDroppable(throttleDuration));
    on<GetMaterialsEvent>(_onGetMaterials,
        transformer: throttleDroppable(throttleDuration));
    on<GetSizesEvent>(_onGetSizes,
        transformer: throttleDroppable(throttleDuration));
    on<GetCategoriesEvent>(_onGetCategories,
        transformer: throttleDroppable(throttleDuration));
    on<GetLocationsEvent>(_onGetLocations,
        transformer: throttleDroppable(throttleDuration));
    on<GetDesignsEvent>(_onGetDesigns,
        transformer: throttleDroppable(throttleDuration));
    on<GetDomainsEvent>(_onGetDomains,
        transformer: throttleDroppable(throttleDuration));
    on<ResetMyPasswordEvent>(_onMyProfile,
        transformer: throttleDroppable(throttleDuration));
    on<SearchProductEvent>(_onSearchProduct,
        transformer: throttleDroppable(throttleDuration));
    on<ShareProductToTiktokEvent>(_onShareProductToTiktok,
        transformer: throttleDroppable(throttleDuration));
    on<RemoveBackgroundEvent>(_onRemoveBackground,
        transformer: throttleDroppable(throttleDuration));
    on<ResetBackgroundRemoverEvent>(_onResetBackgroundRemover,
        transformer: throttleDroppable(throttleDuration));
    on<RemoveBackgroundFromUrlEvent>(_onRemoveBackgroundFromUrl,
        transformer: throttleDroppable(throttleDuration));
  }

  void _onGetColors(GetColorsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(colorStatus: ColorStatus.loading));

    final result = await getColorsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(colorStatus: ColorStatus.failure)),
      (colors) => emit(
          state.copyWith(colors: colors, colorStatus: ColorStatus.success)),
    );
  }

  void _onGetBrands(GetBrandsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(brandStatus: BrandStatus.loading));

    final result = await getBrandsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(brandStatus: BrandStatus.failure)),
      (brands) => emit(
          state.copyWith(brands: brands, brandStatus: BrandStatus.success)),
    );
  }

  void _onGetMaterials(
      GetMaterialsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(materialStatus: MaterialStatus.loading));

    final result = await getMaterialsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(materialStatus: MaterialStatus.failure)),
      (materials) => emit(state.copyWith(
          materials: materials, materialStatus: MaterialStatus.success)),
    );
  }

  void _onGetSizes(GetSizesEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(sizeStatus: SizeStatus.loading));

    final result = await getSizesUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(sizeStatus: SizeStatus.failure)),
      (sizes) =>
          emit(state.copyWith(sizes: sizes, sizeStatus: SizeStatus.success)),
    );
  }

  void _onGetCategories(
      GetCategoriesEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(categoryStatus: CategoryStatus.loading));

    final result = await getCategoriesUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(categoryStatus: CategoryStatus.failure)),
      (categories) => emit(state.copyWith(
          categories: categories, categoryStatus: CategoryStatus.success)),
    );
  }

  void _onGetLocations(
      GetLocationsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(locationStatus: LocationStatus.loading));

    final result = await getLocationUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(locationStatus: LocationStatus.failure)),
      (locations) => emit(state.copyWith(
          locations: locations, locationStatus: LocationStatus.success)),
    );
  }

  void _onGetDesigns(GetDesignsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(designStatus: DesignStatus.loading));

    final result = await getDesignsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(designStatus: DesignStatus.failure)),
      (designs) => emit(
          state.copyWith(designs: designs, designStatus: DesignStatus.success)),
    );
  }

  void _onGetDomains(GetDomainsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(domainStatus: DomainStatus.loading));

    final result = await getDomainsUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(domainStatus: DomainStatus.failure)),
      (domains) => emit(
          state.copyWith(domains: domains, domainStatus: DomainStatus.success)),
    );
  }

  void _onMyProfile(
      ResetMyPasswordEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(myPasswordResetStatus: MyPasswordResetStatus.loading));

    final result = await myProfileUseCase(my_profile.MyProfileParams(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
      token: event.token,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          myPasswordResetStatus: MyPasswordResetStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(
          state.copyWith(myPasswordResetStatus: MyPasswordResetStatus.success)),
    );
  }

  void _onSearchProduct(
      SearchProductEvent event, Emitter<ProductState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
          searchResult: const [], searchStatus: ProductSearchStatus.initial));
      return;
    }

    if (event.query == state.searchQuery) {
      emit(state.copyWith(searchStatus: ProductSearchStatus.loadMore));
    } else {
      emit(state.copyWith(
          searchStatus: ProductSearchStatus.loading, searchResult: []));
    }

    final result = await getProductUseCase(product_usecase.Params(
      token: event.token,
      search: event.query,
      limit: 35,
      skip: event.query == state.searchQuery ? state.searchResult.length : 0,
    ));

    result.fold(
        (failure) =>
            emit(state.copyWith(searchStatus: ProductSearchStatus.failure)),
        (products) {
      if (products.isEmpty) {
        emit(state.copyWith(
            searchStatus: ProductSearchStatus.noMore,
            searchQuery: event.query));
        return;
      }
      emit(state.copyWith(
        searchStatus: ProductSearchStatus.success,
        searchResult: event.query == state.searchQuery
            ? [...state.searchResult, ...products]
            : products,
        searchQuery: event.query,
      ));
    });
  }

  void _onShareProductToTiktok(
      ShareProductToTiktokEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
        shareProductToTiktokStatus: ShareProductToTiktokStatus.loading));

    final result = await shareProductToTiktokUseCase(
        share_product_to_tiktok.ShareProductToTiktokParams(
      accessToken: event.accessToken,
      title: event.title,
      description: event.description,
      disableComments: event.disableComments,
      duetDisabled: event.duetDisabled,
      stitchDisabled: event.stitchDisabled,
      privcayLevel: event.privcayLevel,
      autoAddMusic: event.autoAddMusic,
      source: event.source,
      photoCoverIndex: event.photoCoverIndex,
      photoImages: event.photoImages,
      postMode: event.postMode,
      mediaType: event.mediaType,
      brandContentToggle: event.brandContentToggle,
      brandOrganicToggle: event.brandOrganicToggle,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          shareProductToTiktokStatus: ShareProductToTiktokStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          shareProductToTiktokStatus: ShareProductToTiktokStatus.success)),
    );
  }

  void _onRemoveBackground(
      RemoveBackgroundEvent event, Emitter<ProductState> emit) async {
    emit(
        state.copyWith(backgroundRemoveStatus: BackgroundRemoveStatus.loading));

    final result = await backgroundRemoverUseCase(
        background_remover.BackgroundRemoverParams(
      image: event.image,
      token: event.token,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          backgroundRemoveStatus: BackgroundRemoveStatus.failure,
          errorMessage: failure.message)),
      (image) => emit(state.copyWith(
          backgroundRemoveStatus: BackgroundRemoveStatus.success,
          image: image)),
    );
  }

  void _onRemoveBackgroundFromUrl(
      RemoveBackgroundFromUrlEvent event, Emitter<ProductState> emit) async {
    emit(
        state.copyWith(backgroundRemoveStatus: BackgroundRemoveStatus.loading));

    final result = await backgroundRemoverFromUrlUseCase(
        background_remover_from_url.BackgroundRemoverParams(
      imageUrl: event.imageUrl,
      token: event.token,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          backgroundRemoveStatus: BackgroundRemoveStatus.failure,
          errorMessage: failure.message)),
      (image) => emit(state.copyWith(
          backgroundRemoveStatus: BackgroundRemoveStatus.success,
          image: image)),
    );
  }

  void _onResetBackgroundRemover(
      ResetBackgroundRemoverEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
        backgroundRemoveStatus: BackgroundRemoveStatus.initial, image: null));
  }
}
