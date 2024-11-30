part of 'product_filter_bloc.dart';

@immutable
sealed class ProductFilterEvent {}

class AddSelectedCategoryEvent extends ProductFilterEvent {
  final String category;

  AddSelectedCategoryEvent(this.category);
}

class AddMultipleSelectedCategoriesEvent extends ProductFilterEvent {
  final List<String> categories;

  AddMultipleSelectedCategoriesEvent(this.categories);
}

class RemoveSelectedCategoryEvent extends ProductFilterEvent {
  final String category;

  RemoveSelectedCategoryEvent(this.category);
}

class ClearSelectedCategoriesEvent extends ProductFilterEvent {
  ClearSelectedCategoriesEvent();
}

class AddSelectedColorEvent extends ProductFilterEvent {
  final String color;

  AddSelectedColorEvent(this.color);
}

class AddMultipleSelectedColorsEvent extends ProductFilterEvent {
  final List<String> colors;

  AddMultipleSelectedColorsEvent(this.colors);
}

class RemoveSelectedColorEvent extends ProductFilterEvent {
  final String color;

  RemoveSelectedColorEvent(this.color);
}

class ClearSelectedColorsEvent extends ProductFilterEvent {
  ClearSelectedColorsEvent();
}

class AddSelectedMaterialEvent extends ProductFilterEvent {
  final String material;

  AddSelectedMaterialEvent(this.material);
}

class AddMultipleSelectedMaterialsEvent extends ProductFilterEvent {
  final List<String> materials;

  AddMultipleSelectedMaterialsEvent(this.materials);
}

class RemoveSelectedMaterialEvent extends ProductFilterEvent {
  final String material;

  RemoveSelectedMaterialEvent(this.material);
}

class ClearSelectedMaterialsEvent extends ProductFilterEvent {
  ClearSelectedMaterialsEvent();
}

class AddSelectedSizeEvent extends ProductFilterEvent {
  final String size;

  AddSelectedSizeEvent(this.size);
}

class AddMultipleSelectedSizesEvent extends ProductFilterEvent {
  final List<String> sizes;

  AddMultipleSelectedSizesEvent(this.sizes);
}

class RemoveSelectedSizeEvent extends ProductFilterEvent {
  final String size;

  RemoveSelectedSizeEvent(this.size);
}

class ClearSelectedSizesEvent extends ProductFilterEvent {
  ClearSelectedSizesEvent();
}

class AddSelectedBrandEvent extends ProductFilterEvent {
  final String brand;

  AddSelectedBrandEvent(this.brand);
}

class RemoveSelectedBrandEvent extends ProductFilterEvent {
  final String brand;

  RemoveSelectedBrandEvent(this.brand);
}

class AddMultipleSelectedBrandsEvent extends ProductFilterEvent {
  final List<String> brands;

  AddMultipleSelectedBrandsEvent(this.brands);
}

class ClearSelectedBrandsEvent extends ProductFilterEvent {
  ClearSelectedBrandsEvent();
}

class AddSelectedDesignEvent extends ProductFilterEvent {
  final String design;

  AddSelectedDesignEvent(this.design);
}

class AddMultipleSelectedDesignsEvent extends ProductFilterEvent {
  final List<String> designs;

  AddMultipleSelectedDesignsEvent(this.designs);
}

class RemoveSelectedDesignEvent extends ProductFilterEvent {
  final String design;

  RemoveSelectedDesignEvent(this.design);
}

class ClearSelectedDesignsEvent extends ProductFilterEvent {
  ClearSelectedDesignsEvent();
}

class SetPriceRangeEvent extends ProductFilterEvent {
  final double priceMin;
  final double priceMax;

  SetPriceRangeEvent(this.priceMin, this.priceMax);
}

class ClearPriceRangeEvent extends ProductFilterEvent {
  ClearPriceRangeEvent();
}

class SetConditionEvent extends ProductFilterEvent {
  final String condition;
  SetConditionEvent(this.condition);
}

class ClearConditionEvent extends ProductFilterEvent {
  ClearConditionEvent();
}

class SetTargetEvent extends ProductFilterEvent {
  final String target;
  SetTargetEvent(this.target);
}

class ClearTargetEvent extends ProductFilterEvent {
  ClearTargetEvent();
}

class SetLocationEvent extends ProductFilterEvent {
  final String location;
  final double latitute;
  final double longitude;
  final double distance;

  SetLocationEvent(this.location, this.latitute, this.longitude, this.distance);
}

class ClearLocationEvent extends ProductFilterEvent {
  ClearLocationEvent();
}

class SetSortByEvent extends ProductFilterEvent {
  final String sortBy;
  final String order;

  SetSortByEvent(this.sortBy, this.order);
}

class ClearSortOrderEvent extends ProductFilterEvent {
  ClearSortOrderEvent();
}

class ClearAllEvent extends ProductFilterEvent {
  ClearAllEvent();
}

class SetIsNewEvent extends ProductFilterEvent {
  final bool isNew;

  SetIsNewEvent(this.isNew);
}

class SetIsDeliverableEvent extends ProductFilterEvent {
  final bool isDeliverable;

  SetIsDeliverableEvent(this.isDeliverable);
}

class SetInStockEvent extends ProductFilterEvent {
  final bool inStock;

  SetInStockEvent(this.inStock);
}

class SetIsNegotiableEvent extends ProductFilterEvent {
  final bool isNegotiable;

  SetIsNegotiableEvent(this.isNegotiable);
}

class SetSearchEvent extends ProductFilterEvent {
  final String search;

  SetSearchEvent(this.search);
}
