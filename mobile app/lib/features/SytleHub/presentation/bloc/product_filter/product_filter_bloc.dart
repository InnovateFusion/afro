import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_filter_event.dart';
part 'product_filter_state.dart';

class ProductFilterBloc extends Bloc<ProductFilterEvent, ProductFilterState> {
  ProductFilterBloc() : super(const ProductFilterState()) {
    // category
    on<AddSelectedCategoryEvent>((event, emit) {
      emit(state.copyWith(
        selectedCategories: Set<String>.from(state.selectedCategories)
          ..add(event.category),
      ));
    });

    on<RemoveSelectedCategoryEvent>((event, emit) {
      emit(state.copyWith(
        selectedCategories: Set<String>.from(state.selectedCategories)
          ..remove(event.category),
      ));
    });

    on<ClearSelectedCategoriesEvent>((event, emit) {
      emit(state.copyWith(selectedCategories: const <String>{}));
    });

    // color
    on<AddSelectedColorEvent>((event, emit) {
      emit(state.copyWith(
        selectedColors: Set<String>.from(state.selectedColors)
          ..add(event.color),
      ));
    });
    on<RemoveSelectedColorEvent>((event, emit) {
      emit(state.copyWith(
        selectedColors: Set<String>.from(state.selectedColors)
          ..remove(event.color),
      ));
    });

    on<ClearSelectedColorsEvent>((event, emit) {
      emit(state.copyWith(selectedColors: const <String>{}));
    });

    // material
    on<AddSelectedMaterialEvent>((event, emit) {
      emit(state.copyWith(
        selectedMaterials: Set<String>.from(state.selectedMaterials)
          ..add(event.material),
      ));
    });

    on<RemoveSelectedMaterialEvent>((event, emit) {
      emit(state.copyWith(
        selectedMaterials: Set<String>.from(state.selectedMaterials)
          ..remove(event.material),
      ));
    });

    on<ClearSelectedMaterialsEvent>((event, emit) {
      emit(state.copyWith(selectedMaterials: const <String>{}));
    });

    // size
    on<AddSelectedSizeEvent>((event, emit) {
      emit(state.copyWith(
        selectedSizes: Set<String>.from(state.selectedSizes)..add(event.size),
      ));
    });

    on<RemoveSelectedSizeEvent>((event, emit) {
      emit(state.copyWith(
        selectedSizes: Set<String>.from(state.selectedSizes)
          ..remove(event.size),
      ));
    });

    on<ClearSelectedSizesEvent>((event, emit) {
      emit(state.copyWith(selectedSizes: const <String>{}));
    });

    // brand
    on<AddSelectedBrandEvent>((event, emit) {
      emit(state.copyWith(
        selectedBrands: Set<String>.from(state.selectedBrands)
          ..add(event.brand),
      ));
    });

    on<RemoveSelectedBrandEvent>((event, emit) {
      emit(state.copyWith(
        selectedBrands: Set<String>.from(state.selectedBrands)
          ..remove(event.brand),
      ));
    });

    on<ClearSelectedBrandsEvent>((event, emit) {
      emit(state.copyWith(selectedBrands: const <String>{}));
    });

    // design
    on<AddSelectedDesignEvent>((event, emit) {
      emit(state.copyWith(
        selectedDesigns: Set<String>.from(state.selectedDesigns)
          ..add(event.design),
      ));
    });

    on<RemoveSelectedDesignEvent>((event, emit) {
      emit(state.copyWith(
        selectedDesigns: Set<String>.from(state.selectedDesigns)
          ..remove(event.design),
      ));
    });

    on<ClearSelectedDesignsEvent>((event, emit) {
      emit(state.copyWith(selectedDesigns: const <String>{}));
    });

    // price
    on<SetPriceRangeEvent>((event, emit) {
      emit(state.copyWith(priceMin: event.priceMin, priceMax: event.priceMax));
    });

    on<ClearPriceRangeEvent>((event, emit) {
      emit(state.copyWith(priceMin: 1, priceMax: 10000));
    });

    // conditions
    on<SetConditionEvent>((event, emit) {
      emit(state.copyWith(condition: event.condition));
    });

    on<ClearConditionEvent>((event, emit) {
      emit(state.copyWith(condition: ""));
    });

    on<ClearTargetEvent>((event, emit) {
      emit(state.copyWith(target: ""));
    });

    // location

    on<SetLocationEvent>((event, emit) {
      emit(state.copyWith(
          location: event.location,
          latitute: event.latitute,
          longitude: event.longitude,
          distance: event.distance));
    });

    on<ClearLocationEvent>((event, emit) {
      emit(
          state.copyWith(location: "", latitute: 0, longitude: 0, distance: 0));
    });

    // sort
    on<SetSortByEvent>((event, emit) {
      emit(state.copyWith(sort: event.sortBy, order: event.order));
    });

    on<ClearSortOrderEvent>((event, emit) {
      emit(state.copyWith(sort: "", order: ""));
    });

    // clear all
    on<ClearAllEvent>((event, emit) {
      emit(const ProductFilterState());
    });

    // add Multiple Category
    on<AddMultipleSelectedCategoriesEvent>((event, emit) {
      emit(state.copyWith(
        selectedCategories: Set<String>.from(state.selectedCategories)
          ..addAll(event.categories),
      ));
    });

    // add Multiple Colors
    on<AddMultipleSelectedColorsEvent>((event, emit) {
      emit(state.copyWith(
        selectedColors: Set<String>.from(state.selectedColors)
          ..addAll(event.colors),
      ));
    });

    // add Multiple Materials
    on<AddMultipleSelectedMaterialsEvent>((event, emit) {
      emit(state.copyWith(
        selectedMaterials: Set<String>.from(state.selectedMaterials)
          ..addAll(event.materials),
      ));
    });

    // add Multiple Sizes
    on<AddMultipleSelectedSizesEvent>((event, emit) {
      emit(state.copyWith(
        selectedSizes: Set<String>.from(state.selectedSizes)
          ..addAll(event.sizes),
      ));
    });

    // add Multiple Brands
    on<AddMultipleSelectedBrandsEvent>((event, emit) {
      emit(state.copyWith(
        selectedBrands: Set<String>.from(state.selectedBrands)
          ..addAll(event.brands),
      ));
    });

    // add Multiple Designs
    on<AddMultipleSelectedDesignsEvent>((event, emit) {
      emit(state.copyWith(
        selectedDesigns: Set<String>.from(state.selectedDesigns)
          ..addAll(event.designs),
      ));
    });

    on<SetIsNewEvent>((event, emit) {
      emit(state.copyWith(isNew: event.isNew));
    });

    on<SetIsDeliverableEvent>((event, emit) {
      emit(state.copyWith(isDeliverable: event.isDeliverable));
    });

    on<SetInStockEvent>((event, emit) {
      emit(state.copyWith(inStock: event.inStock));
    });

    on<SetIsNegotiableEvent>((event, emit) {
      emit(state.copyWith(isNegotiable: event.isNegotiable));
    });
  }
}
