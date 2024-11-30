part of 'shop_bloc.dart';

sealed class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class GetAllShopEvent extends ShopEvent {
  final String token;
  final String? search;
  final List<String>? category;
  final int? rating;
  final int? verified;
  final bool? active;
  final String? ownerId;
  final double? latitudes;
  final double? longitudes;
  final double? radiusInKilometers;
  final String? condition;
  final String? sortBy;
  final String? sortOrder;

  const GetAllShopEvent({
    required this.token,
    this.search,
    this.category,
    this.rating,
    this.verified,
    this.active,
    this.ownerId,
    this.latitudes,
    this.longitudes,
    this.radiusInKilometers,
    this.condition,
    this.sortBy,
    this.sortOrder,
  });
}

class GetShopByIdEvent extends ShopEvent {
  final String id;

  const GetShopByIdEvent({
    required this.id,
  });
}

class GetShopProductByIdEvent extends ShopEvent {
  final String id;
  final String token;

  const GetShopProductByIdEvent({
    required this.id,
    required this.token,
  });
}

class GetShopProductsImagesEvent extends ShopEvent {
  final String shopId;

  const GetShopProductsImagesEvent({
    required this.shopId,
  });
}

class GetShopProductsVideosEvent extends ShopEvent {
  final String shopId;

  const GetShopProductsVideosEvent({
    required this.shopId,
  });
}

class GetShopReviewsEvent extends ShopEvent {
  final String shopId;
  final String? userId;
  final String? sortBy;
  final String? sortOrder;
  final int? rating;

  const GetShopReviewsEvent({
    required this.shopId,
    this.userId,
    this.sortBy,
    this.sortOrder,
    this.rating,
  });
}

class GetShopProductsEvent extends ShopEvent {
  final String token;
  final String shopId;
  final String? sortBy;
  final String? sortOrder;

  const GetShopProductsEvent({
    required this.token,
    required this.shopId,
    this.sortBy,
    this.sortOrder,
  });
}

class GetShopWorkingHoursEvent extends ShopEvent {
  final String shopId;

  const GetShopWorkingHoursEvent({
    required this.shopId,
  });
}

class GetMyShopEvent extends ShopEvent {
  final String userId;
  final String? token;

  const GetMyShopEvent({
    required this.userId,
    this.token,
  });
}

class AddProductEvent extends ShopEvent {
  final String token;
  final String title;
  final String description;
  final int price;
  final bool isNew;
  final bool isDeliverable;
  final int availableQuantity;
  final bool isNegotiable;
  final bool inStock;
  final String status;
  final String? videoUrl;
  final String shopId;
  final List<XFile> fileImages;
  final List<ImageEntity> images;
  final List<String> colorIds;
  final List<String> sizeIds;
  final List<String> categoryIds;
  final List<String> brandIds;
  final List<String> materialIds;
  final List<String> designIds;

  const AddProductEvent({
    required this.token,
    required this.title,
    required this.description,
    required this.price,
    required this.shopId,
    required this.isNew,
    required this.isDeliverable,
    required this.availableQuantity,
    required this.isNegotiable,
    required this.inStock,
    required this.fileImages,
    required this.images,
    required this.colorIds,
    required this.sizeIds,
    required this.categoryIds,
    required this.brandIds,
    required this.materialIds,
    required this.designIds,
    required this.status,
    this.videoUrl,
  });
}

class DeleteProductEvent extends ShopEvent {
  final ProductEntity product;
  final String token;

  const DeleteProductEvent({
    required this.product,
    required this.token,
  });
}

class GetFilteredProductsEvent extends ShopEvent {
  final String token;
  final String? search;
  final List<String>? colorIds;
  final List<String>? sizeIds;
  final List<String>? categoryIds;
  final List<String>? brandIds;
  final List<String>? materialIds;
  final List<String>? designIds;
  final bool? isNegotiable;
  final bool? inStock;
  final bool? isNew;
  final bool? isDeliverable;
  final double? minPrice;
  final double? maxPrice;
  final int? minQuantity;
  final int? maxQuantity;
  final double? latitudes;
  final double? longitudes;
  final double? radiusInKilometers;
  final String? condition;
  final String? sortBy;
  final String? sortOrder;
  final int? skip = 0;
  final int? limit = 10;

  const GetFilteredProductsEvent({
    required this.token,
    this.search,
    this.colorIds,
    this.sizeIds,
    this.categoryIds,
    this.brandIds,
    this.designIds,
    this.materialIds,
    this.isNegotiable,
    this.inStock,
    this.isNew,
    this.isDeliverable,
    this.minPrice,
    this.maxPrice,
    this.minQuantity,
    this.maxQuantity,
    this.latitudes,
    this.longitudes,
    this.radiusInKilometers,
    this.condition,
    this.sortBy,
    this.sortOrder,
  });
}

class ClearFilteredProductsEvent extends ShopEvent {}

class GetProductsEvent extends ShopEvent {
  final String token;
  final String? search;
  final List<String>? colorIds;
  final List<String>? sizeIds;
  final List<String>? categoryIds;
  final List<String>? brandIds;
  final List<String>? materialIds;
  final List<String>? designIds;
  final bool? isNegotiable;
  final bool? inStock;
  final bool? isNew;
  final bool? isDeliverable;
  final double? minPrice;
  final double? maxPrice;
  final String? shopId;
  final String? status;
  final double? latitudes;
  final double? longitudes;
  final double? radiusInKilometers;
  final String? condition;
  final String? sortBy;
  final String? sortOrder;
  final int? homePageTabIndex;
  final int? skip = 0;
  final int? limit = 10;

  const GetProductsEvent({
    required this.token,
    this.search,
    this.colorIds,
    this.sizeIds,
    this.categoryIds,
    this.brandIds,
    this.designIds,
    this.materialIds,
    this.isNegotiable,
    this.isNew,
    this.isDeliverable,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.shopId,
    this.status,
    this.homePageTabIndex,
    this.latitudes,
    this.longitudes,
    this.radiusInKilometers,
    this.condition,
    this.sortBy,
    this.sortOrder,
  });
}

class ClearProductsEvent extends ShopEvent {}

class GetFavoriteProductsEvent extends ShopEvent {
  final String token;
  final int? skip = 0;
  final int? limit = 10;

  const GetFavoriteProductsEvent({
    required this.token,
  });
}

class AddOrRemoveFavoriteProductEvent extends ShopEvent {
  final String token;
  final ProductEntity product;

  const AddOrRemoveFavoriteProductEvent({
    required this.token,
    required this.product,
  });
}

class UpdateProductEvent extends ShopEvent {
  final String id;
  final String shopId;
  final String token;
  final String title;
  final String description;
  final int price;
  final bool isNew;
  final bool isDeliverable;
  final int availableQuantity;
  final bool isNegotiable;
  final bool inStock;
  final List<XFile> fileImages;
  final List<ImageEntity> images;
  final List<String> colorIds;
  final List<String> sizeIds;
  final List<String> categoryIds;
  final List<String> brandIds;
  final List<String> materialIds;
  final List<String> designIds;
  final String? videoUrl;
  final String status;

  const UpdateProductEvent({
    required this.id,
    required this.shopId,
    required this.token,
    required this.images,
    required this.title,
    required this.description,
    required this.price,
    required this.isNew,
    required this.isDeliverable,
    required this.availableQuantity,
    required this.isNegotiable,
    required this.inStock,
    required this.fileImages,
    required this.colorIds,
    required this.sizeIds,
    required this.categoryIds,
    required this.brandIds,
    required this.materialIds,
    required this.designIds,
    required this.videoUrl,
    required this.status,
  });
}

class GetArchivedProductsEvent extends ShopEvent {
  final String token;

  const GetArchivedProductsEvent({
    required this.token,
  });
}

class GetDraftProductsEvent extends ShopEvent {
  final String token;

  const GetDraftProductsEvent({
    required this.token,
  });
}

class ArchiveProductEvent extends ShopEvent {
  final ProductEntity product;
  final String token;

  const ArchiveProductEvent({
    required this.product,
    required this.token,
  });
}

class UnArchiveProductEvent extends ShopEvent {
  final ProductEntity product;
  final String token;

  const UnArchiveProductEvent({
    required this.product,
    required this.token,
  });
}

class DraftProductEvent extends ShopEvent {
  final ProductEntity product;
  final String token;

  const DraftProductEvent({
    required this.product,
    required this.token,
  });
}

class UnDraftProductEvent extends ShopEvent {
  final ProductEntity product;
  final String token;

  const UnDraftProductEvent({
    required this.product,
    required this.token,
  });
}

class AddReviewEvent extends ShopEvent {
  final String token;
  final String shopId;
  final String review;
  final int rating;

  const AddReviewEvent({
    required this.token,
    required this.shopId,
    required this.review,
    required this.rating,
  });
}

class UpdateReviewEvent extends ShopEvent {
  final String token;
  final String reviewId;
  final String review;
  final int rating;
  final String shopId;

  const UpdateReviewEvent({
    required this.token,
    required this.reviewId,
    required this.review,
    required this.rating,
    required this.shopId,
  });
}

class DeleteReviewEvent extends ShopEvent {
  final ReviewEntity review;
  final String token;

  const DeleteReviewEvent({
    required this.review,
    required this.token,
  });
}

class GetShopAnalyticEvent extends ShopEvent {
  final String id;
  final String token;

  const GetShopAnalyticEvent({
    required this.id,
    required this.token,
  });
}

class CreateShopEvent extends ShopEvent {
  final String token;
  final String name;
  final String description;
  final Address address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? website;
  final File logo;
  final List<String> categories;
  final Map<String, String> socialMedia;
  final Map<String, String> workingHours;

  const CreateShopEvent({
    required this.token,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.logo,
    required this.categories,
    required this.socialMedia,
    required this.workingHours,
    this.website,
  });
}

class SearchShopEvent extends ShopEvent {
  final String query;

  const SearchShopEvent({required this.query});
}

class SetShopEvent extends ShopEvent {
  final ShopEntity shop;

  const SetShopEvent({required this.shop});
}

class ShopImageUploadEvent extends ShopEvent {
  final String token;
  final bool isLogo;
  final File image;

  const ShopImageUploadEvent({
    required this.token,
    required this.isLogo,
    required this.image,
  });
}

class UpdateShopEvent extends ShopEvent {
  final String token;
  final String shopId;
  final String? name;
  final String? description;
  final String? street;
  final String? subLocality;
  final String? subAdministrativeArea;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? website;
  final List<String>? categories;
  final Map<String, String>? socialMedia;

  const UpdateShopEvent({
    required this.token,
    required this.shopId,
    this.name,
    this.description,
    this.street,
    this.subLocality,
    this.subAdministrativeArea,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.categories,
    this.website,
    this.socialMedia,
  });
}

class UpdateShopWorkingHourEvent extends ShopEvent {
  final String token;
  final List<WorkingHourEntity> workingHours;

  const UpdateShopWorkingHourEvent({
    required this.token,
    required this.workingHours,
  });
}

class DeleteShopEvent extends ShopEvent {
  final String token;
  final String id;

  const DeleteShopEvent({
    required this.token,
    required this.id,
  });
}

class ResetShopImageUploadEvent extends ShopEvent {
  const ResetShopImageUploadEvent();
}

class ClearShopEvent extends ShopEvent {
  const ClearShopEvent();
}

class ChangeStatusToInitialEvent extends ShopEvent {
  const ChangeStatusToInitialEvent();
}

class GetProductAnalyticEvent extends ShopEvent {
  final String id;
  final String token;

  const GetProductAnalyticEvent({
    required this.id,
    required this.token,
  });
}

class FollowOrUnFollowShopEvent extends ShopEvent {
  final String token;
  final String shopId;

  const FollowOrUnFollowShopEvent({
    required this.token,
    required this.shopId,
  });
}

class MakeContactEvent extends ShopEvent {
  final String token;
  final String productId;

  const MakeContactEvent({
    required this.token,
    required this.productId,
  });
}

class GetFollowingShopProductsEvent extends ShopEvent {
  final String token;
  final int homePageTabIndex;

  const GetFollowingShopProductsEvent({
    required this.token,
    required this.homePageTabIndex,
  });
}

class ShopVerificationRequestEvent extends ShopEvent {
  final String token;
  final String shopId;
  final String ownerIdentityCardUrl;
  final String businessRegistrationNumber;
  final String businessRegistrationDocumentUrl;
  final String youPhotoUrl;

  const ShopVerificationRequestEvent({
    required this.token,
    required this.shopId,
    required this.ownerIdentityCardUrl,
    required this.businessRegistrationNumber,
    required this.businessRegistrationDocumentUrl,
    required this.youPhotoUrl,
  });
}

class RequestShopVerificationEvent extends ShopEvent {
  final String id;
  final String token;
  final String ownerIdentityCardUrl;
  final String businessRegistrationNumber;
  final String businessRegistrationDocumentUrl;
  final String ownerSelfieUrl;

  const RequestShopVerificationEvent({
    required this.id,
    required this.token,
    required this.ownerIdentityCardUrl,
    required this.businessRegistrationNumber,
    required this.businessRegistrationDocumentUrl,
    required this.ownerSelfieUrl,
  });
}
