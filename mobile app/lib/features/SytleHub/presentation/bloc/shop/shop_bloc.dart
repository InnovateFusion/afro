import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_favorite.dart'
    as get_favorite;
import 'package:style_hub/features/SytleHub/domain/usecases/product/get_product.dart'
    as product_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/add_image.dart'
    as add_image;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/add_or_remove_favorite.dart'
    as add_or_remove_favorite;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/add_product.dart'
    as add_product;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/add_review.dart'
    as add_review;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/add_working_hour.dart'
    as add_working_hour;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/create_shop.dart'
    as create_shop;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/delete_product.dart'
    as delete_product;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/delete_review.dart'
    as delete_review;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/delete_shop.dart'
    as delete_shop;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/delete_working_hour.dart'
    as delete_working_hour;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/follow_unfollow_shop.dart'
    as follow_unfollow_shop;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_product_by_id.dart'
    as get_product_by_id;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_shop.dart'
    as get_shop;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_shop_by_id.dart'
    as get_shop_by_id;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_shop_products.dart'
    as get_shop_products;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_shop_products_images.dart'
    as get_shop_products_images;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_shop_products_video.dart'
    as get_shop_products_video;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_shop_reviews.dart'
    as get_shop_reviews;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/get_shop_working_hour.dart'
    as get_shop_working_hour;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/product_analytic.dart'
    as product_analytic;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/shop_analytic.dart'
    as shop_analytic;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/update_product.dart'
    as update_product;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/update_review.dart'
    as update_review;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/update_shop.dart'
    as update_shop;
import 'package:style_hub/features/SytleHub/domain/usecases/shop/update_working_hour.dart'
    as update_working_hour;
import 'package:style_hub/features/SytleHub/presentation/pages/location_picker.dart';

import '../../../domain/entities/product/image_entity.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/entities/shop/analytic_product_entity.dart';
import '../../../domain/entities/shop/analytic_shop_entity.dart';
import '../../../domain/entities/shop/review_entity.dart';
import '../../../domain/entities/shop/shop_entity.dart';
import '../../../domain/entities/shop/working_hour_entity.dart';
import '../../../domain/usecases/shop/get_following_shop_products.dart'
    as get_following_shop_products;
import '../../../domain/usecases/shop/make_contact.dart' as make_contact;
import '../../../domain/usecases/shop/shop_verification_request.dart'
    as shop_verification_request;

part 'shop_event.dart';
part 'shop_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final get_product_by_id.GetProductByIdUseCase getProductByIdUseCase;
  final get_following_shop_products.GetFollowingShopProducts
      getFollowingShopProductsUseCase;
  final get_shop_by_id.GetShopByIdUseCase getShopByIdUseCase;
  final get_shop_products_images.GetShopProductsImageUseCase
      getShopProductsImageUseCase;
  final get_shop_products_video.GetShopProductsVideoUseCase
      getShopProductsVideoUseCase;
  final get_shop_products.GetShopProductUseCase getShopProductUseCase;
  final get_shop_reviews.GetShopReviewUseCase getShopReviewUseCase;
  final get_shop_working_hour.GetShopWorkingHourUseCase
      getShopWorkingHourUseCase;
  final get_shop.GetShopUseCase getShopUseCase;
  final add_image.AddImageUseCase addImageUseCase;
  final add_product.AddProductsUseCase addProductsUseCase;
  final delete_product.DeleteProductByIdUseCase deleteProductByIdUseCase;
  final product_usecase.GetProductsUseCase getProductsUseCase;
  final get_favorite.GetFavoriteUseCase getFavoriteUseCase;
  final add_or_remove_favorite.AddOrRemoveFavoriteUseCase
      addOrRemoveFavoriteUseCase;
  final update_product.UpdateProductsUseCase updateProductsUseCase;
  final add_review.AddReviewUseCase addReviewUseCase;
  final update_review.UpdateReviewUseCase updateReviewUseCase;
  final delete_review.DeleteReviewUseCase deleteReviewUseCase;
  final shop_analytic.ShopAnalyticUseCase shopAnalyticUseCase;
  final create_shop.CreateShopUseCase createShopUseCase;
  final add_working_hour.AddWorkingHourUseCase addWorkingHourUseCase;
  final update_working_hour.UpdateWorkingHourUseCase updateWorkingHourUseCase;
  final update_shop.UpdateShopUseCase updateShopUseCase;
  final delete_working_hour.DeleteWorkingHourUseCase deleteWorkingHourUseCase;
  final delete_shop.DeleteShopUseCase deleteShopUseCase;
  final product_analytic.ProductAnalyticUseCase productAnalyticUseCase;
  final make_contact.MakeContactUseCase makeContactUseCase;
  final follow_unfollow_shop.FollowUnfollowShopUseCase
      followUnfollowShopUseCase;

  final shop_verification_request.ShopVerificationRequestUsecase
      shopVerificationRequestUseCase;

  ShopBloc({
    required this.getProductByIdUseCase,
    required this.getFollowingShopProductsUseCase,
    required this.getFavoriteUseCase,
    required this.getShopByIdUseCase,
    required this.getShopProductsImageUseCase,
    required this.getShopProductsVideoUseCase,
    required this.getShopProductUseCase,
    required this.getShopReviewUseCase,
    required this.getShopWorkingHourUseCase,
    required this.getShopUseCase,
    required this.addImageUseCase,
    required this.addProductsUseCase,
    required this.deleteProductByIdUseCase,
    required this.getProductsUseCase,
    required this.addOrRemoveFavoriteUseCase,
    required this.updateProductsUseCase,
    required this.addReviewUseCase,
    required this.updateReviewUseCase,
    required this.deleteReviewUseCase,
    required this.shopAnalyticUseCase,
    required this.createShopUseCase,
    required this.addWorkingHourUseCase,
    required this.updateWorkingHourUseCase,
    required this.updateShopUseCase,
    required this.deleteWorkingHourUseCase,
    required this.deleteShopUseCase,
    required this.productAnalyticUseCase,
    required this.makeContactUseCase,
    required this.followUnfollowShopUseCase,
    required this.shopVerificationRequestUseCase,
  }) : super(const ShopState()) {
    on<ShopVerificationRequestEvent>(_shopVerificationRequest,
        transformer: throttleDroppable(throttleDuration));

    on<GetAllShopEvent>(_getAllShop,
        transformer: throttleDroppable(throttleDuration));

    on<GetShopByIdEvent>(_getShopById,
        transformer: throttleDroppable(throttleDuration));

    on<GetShopProductByIdEvent>(_getShopProductById,
        transformer: throttleDroppable(throttleDuration));

    on<GetShopProductsImagesEvent>(_getShopProductsImages,
        transformer: throttleDroppable(throttleDuration));

    on<GetShopProductsVideosEvent>(_getShopProductsVideo,
        transformer: throttleDroppable(throttleDuration));
    on<GetShopProductsEvent>(_getShopProducts,
        transformer: throttleDroppable(throttleDuration));
    on<GetShopReviewsEvent>(_getShopReviews,
        transformer: throttleDroppable(throttleDuration));
    on<GetShopWorkingHoursEvent>(_getShopWorkingHours,
        transformer: throttleDroppable(throttleDuration));
    on<GetMyShopEvent>(_getMyShop,
        transformer: throttleDroppable(throttleDuration));
    on<AddProductEvent>(_addProduct,
        transformer: throttleDroppable(throttleDuration));
    on<DeleteProductEvent>(_deleteProduct,
        transformer: throttleDroppable(throttleDuration));

    on<SearchShopEvent>(_searchShop,
        transformer: throttleDroppable(throttleDuration));

    on<GetFilteredProductsEvent>(_onGetFilteredProducts,
        transformer: throttleDroppable(throttleDuration));

    on<ClearFilteredProductsEvent>((event, emit) {
      emit(state.copyWith(
          filteredProducts: [],
          filteredProductStatus: FilteredProductStatus.initial));
    });

    on<ClearShopEvent>((event, emit) {
      emit(const ShopState());
    });

    on<GetProductsEvent>(_onGetProducts,
        transformer: throttleDroppable(throttleDuration));
    on<ClearProductsEvent>((event, emit) {
      emit(state.copyWith(
          products: {}, mainProductStatus: MainProductsStatus.initial));
    });

    on<ResetShopImageUploadEvent>((event, emit) {
      emit(
          state.copyWith(shopImageUploadStatus: ShopImageUploadStatus.initial));
    });

    on<ChangeStatusToInitialEvent>((event, emit) {
      emit(
        state.copyWith(
          shopProductImageStatus: ShopProductImageStatus.initial,
          shopImageUploadStatus: ShopImageUploadStatus.initial,
          addProductStatus: AddProductStatus.initial,
          addReviewStatus: AddReviewStatus.initial,
          archiveProductsStatus: ArchiveProductsStatus.initial,
          deleteProductStatus: DeleteProductStatus.initial,
          deleteShopStatus: DeleteShopStatus.initial,
          draftProductsStatus: DraftProductsStatus.initial,
          favoriteProductsStatus: FavoriteProductsStatus.initial,
          updateProductStatus: UpdateProductStatus.initial,
          errorMessage: '',
        ),
      );
    });

    on<ShopImageUploadEvent>(_shopImageUpload,
        transformer: throttleDroppable(throttleDuration));

    on<GetFavoriteProductsEvent>(_getFavoriteProducts,
        transformer: throttleDroppable(throttleDuration));

    on<AddOrRemoveFavoriteProductEvent>(_addOrRemoveFavoriteProduct,
        transformer: throttleDroppable(throttleDuration));

    on<GetArchivedProductsEvent>(_getArchiveProducts,
        transformer: throttleDroppable(throttleDuration));

    on<GetDraftProductsEvent>(_getDraftProducts,
        transformer: throttleDroppable(throttleDuration));

    on<UpdateProductEvent>(_updateProduct,
        transformer: throttleDroppable(throttleDuration));

    on<ArchiveProductEvent>(_archiveProduct,
        transformer: throttleDroppable(throttleDuration));

    on<UnArchiveProductEvent>(_unArchiveProduct,
        transformer: throttleDroppable(throttleDuration));

    on<DraftProductEvent>(_draftProduct,
        transformer: throttleDroppable(throttleDuration));

    on<UnDraftProductEvent>(_unDraftProduct,
        transformer: throttleDroppable(throttleDuration));

    on<AddReviewEvent>(_addReview,
        transformer: throttleDroppable(throttleDuration));

    on<UpdateReviewEvent>(_updateReview,
        transformer: throttleDroppable(throttleDuration));

    on<DeleteReviewEvent>(_deleteReview,
        transformer: throttleDroppable(throttleDuration));

    on<GetShopAnalyticEvent>(_getShopAnalytic,
        transformer: throttleDroppable(throttleDuration));

    on<CreateShopEvent>(_createShop,
        transformer: throttleDroppable(throttleDuration));

    on<SetShopEvent>((event, emit) {
      emit(state.copyWith(shops: {event.shop.id: event.shop, ...state.shops}));
    });

    on<UpdateShopEvent>(_updateShop,
        transformer: throttleDroppable(throttleDuration));

    on<UpdateShopWorkingHourEvent>(_updateShopWorkingHour,
        transformer: throttleDroppable(throttleDuration));

    on<DeleteShopEvent>(_deleteShop,
        transformer: throttleDroppable(throttleDuration));

    on<GetProductAnalyticEvent>(_getProductAnalytic,
        transformer: throttleDroppable(throttleDuration));

    on<FollowOrUnFollowShopEvent>(_followOrUnFollowShop,
        transformer: throttleDroppable(throttleDuration));

    on<MakeContactEvent>(_makeContact,
        transformer: throttleDroppable(throttleDuration));

    on<GetFollowingShopProductsEvent>(_getFollowingShopProducts,
        transformer: throttleDroppable(throttleDuration));

    on<RequestShopVerificationEvent>(_requestShopVerification,
        transformer: throttleDroppable(throttleDuration));
  }

  void _getAllShop(
    GetAllShopEvent event,
    Emitter<ShopState> emit,
  ) async {
    final newParameter = ShopFilterParamter(
        selectedCategories: {...?event.category},
        selectedLatitude: event.latitudes,
        selectedLongitude: event.longitudes,
        selectedRating: event.rating?.toDouble(),
        selectedVefification: event.verified);

    if (state.shopFilterParamter?.isObjectSame(newParameter) ?? false) {
      emit(state.copyWith(shopsListStatus: ShopsListStatus.loadMore));
    } else {
      if (state.myShopId != null) {
        emit(state.copyWith(shops: {
          state.myShopId!: state.shops[state.myShopId!]!,
        }));
      } else {
        emit(state
            .copyWith(shopsListStatus: ShopsListStatus.loading, shops: {}));
      }
    }

    final result = await getShopUseCase(get_shop.Params(
      token: event.token,
      search: event.search,
      category: event.category,
      rating: event.rating,
      verified: event.verified,
      active: event.active,
      ownerId: event.ownerId,
      latitudes: event.latitudes,
      longitudes: event.longitudes,
      radiusInKilometers: event.radiusInKilometers,
      condition: event.condition,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
      skip: (state.shops.isEmpty || state.shops.length == 1)
          ? 0
          : state.shops.length,
      limit: 20,
    ));
    result.fold(
        (failure) => emit(state.copyWith(
            errorMessage: failure.message,
            shopsListStatus: ShopsListStatus.failure)), (shops) {
      if (shops.isEmpty) {
        emit(state.copyWith(
          shopsListStatus: ShopsListStatus.loaded,
          shopFilterParamter: newParameter,
        ));
        return;
      }
      emit(
        state.copyWith(
          shopsListStatus: ShopsListStatus.success,
          shops: {...state.shops, ...Map.fromIterable(shops, key: (e) => e.id)},
          shopFilterParamter: newParameter,
        ),
      );
    });
  }

  void _getShopById(
    GetShopByIdEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (state.shops.containsKey(event.id)) {
      emit(state.copyWith(shopStatus: ShopStatus.success));
      return;
    }
    emit(state.copyWith(shopStatus: ShopStatus.loading));
    final result = await getShopByIdUseCase(get_shop_by_id.Params(
      id: event.id,
    ));
    result.fold(
        (failure) => emit(state.copyWith(
            errorMessage: failure.message,
            shopStatus: ShopStatus.failure)), (shop) {
      final shopMap = {...state.shops};
      shopMap[shop.id] = shop;
      emit(
        state.copyWith(
          shopStatus: ShopStatus.success,
          shops: shopMap,
        ),
      );
    });
  }

  void _getShopProductById(
    GetShopProductByIdEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(
        getShopProductByIdStatus: GetShopProductByIdStatus.loading));
    final result = await getProductByIdUseCase(get_product_by_id.Params(
      id: event.id,
    ));
    result.fold(
        (failure) => emit(state.copyWith(
            errorMessage: failure.message,
            getShopProductByIdStatus: GetShopProductByIdStatus.failure)),
        (product) {
      final shopMap = {...state.shops};
      shopMap[product.shopInfo.id] =
          shopMap[product.shopInfo.id]!.copyWith(products: {
        ...shopMap[product.shopInfo.id]!.products,
        product.id: product,
      });
      emit(
        state.copyWith(
          product: product,
          getShopProductByIdStatus: GetShopProductByIdStatus.success,
          shops: shopMap,
        ),
      );
    });
  }

  void _getShopProductsImages(
    GetShopProductsImagesEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (!state.shops.containsKey(event.shopId)) {
      return;
    }
    if (state.shops[event.shopId]!.images.isNotEmpty) {
      emit(state.copyWith(
          shopProductImageStatus: ShopProductImageStatus.loadMore));
    } else {
      emit(state.copyWith(
          shopProductImageStatus: ShopProductImageStatus.loading));
    }

    final result =
        await getShopProductsImageUseCase(get_shop_products_images.Params(
      shopId: event.shopId,
      skip: state.shops[event.shopId]!.images.isEmpty
          ? 0
          : state.shops[event.shopId]!.images.length,
      limit: 20,
    ));
    result.fold(
      (failure) {
        emit(state.copyWith(
            errorMessage: failure.message,
            shopProductImageStatus: ShopProductImageStatus.failure));
      },
      (images) {
        if (images.isEmpty) {
          emit(state.copyWith(
              shopProductImageStatus: ShopProductImageStatus.loaded));
          return;
        }

        Map<String, ImageEntity> newImages = {
          ...state.shops[event.shopId]!.images,
        };

        for (var image in images) {
          newImages[image.id] = image;
        }

        Map<String, ShopEntity> newShops = {...state.shops};
        newShops[event.shopId] =
            newShops[event.shopId]!.copyWith(images: newImages);

        emit(state.copyWith(
            shops: newShops,
            shopProductImageStatus: ShopProductImageStatus.success));
      },
    );
  }

  void _getShopProductsVideo(
    GetShopProductsVideosEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (!state.shops.containsKey(event.shopId)) {
      return;
    }

    emit(
        state.copyWith(shopProductVideoStatus: ShopProductVideoStatus.loading));

    final result =
        await getShopProductsVideoUseCase(get_shop_products_video.Params(
      shopId: event.shopId,
      skip: state.shops[event.shopId]!.videos.isEmpty
          ? 0
          : state.shops[event.shopId]!.videos.length,
      limit: 10,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          shopProductVideoStatus: ShopProductVideoStatus.failure)),
      (videos) {
        if (videos.isEmpty) {
          emit(state.copyWith(
              shopProductVideoStatus: ShopProductVideoStatus.loaded));
          return;
        }

        List<String> newVideos = [
          ...state.shops[event.shopId]!.videos,
          ...videos,
        ];

        Map<String, ShopEntity> newShops = {...state.shops};
        newShops[event.shopId] =
            newShops[event.shopId]!.copyWith(videos: newVideos);

        emit(state.copyWith(
            shops: newShops,
            shopProductVideoStatus: ShopProductVideoStatus.success));
      },
    );
  }

  void _getShopProducts(
    GetShopProductsEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (!state.shops.containsKey(event.shopId)) {
      return;
    }

    if (state.shops[event.shopId]!.products.isNotEmpty) {
      emit(state.copyWith(shopProductsStatus: ShopProductsStatus.loadMore));
    } else {
      emit(state.copyWith(shopProductsStatus: ShopProductsStatus.loading));
    }

    final result = await getShopProductUseCase(get_shop_products.Params(
        token: event.token,
        shopId: event.shopId,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        limit: 16,
        skip: state.shops[event.shopId]!.products.isEmpty
            ? 0
            : state.shops[event.shopId]!.products.length));
    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          shopProductsStatus: ShopProductsStatus.failure)),
      (products) {
        if (products.isEmpty) {
          emit(state.copyWith(shopProductsStatus: ShopProductsStatus.loaded));
          return;
        }
        Map<String, ProductEntity> newProducts = {
          ...state.shops[event.shopId]!.products
        };
        for (var product in products) {
          newProducts[product.id] = product;
        }
        Map<String, ShopEntity> newShops = {...state.shops};
        ShopEntity updatedShop =
            newShops[event.shopId]!.copyWith(products: newProducts);
        newShops[event.shopId] = updatedShop;
        emit(state.copyWith(
            shops: newShops, shopProductsStatus: ShopProductsStatus.success));
      },
    );
  }

  void _getShopReviews(
    GetShopReviewsEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (!state.shops.containsKey(event.shopId)) {
      return;
    }

    if (state.shops[event.shopId]!.reviews.isNotEmpty) {
      emit(state.copyWith(
          shopProductReviewStatus: ShopProductReviewStatus.loadMore));
    } else {
      emit(state.copyWith(
          shopProductReviewStatus: ShopProductReviewStatus.loading));
    }

    final result = await getShopReviewUseCase(get_shop_reviews.Params(
        shopId: event.shopId,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        limit: 10,
        skip: state.shops[event.shopId]!.reviews.isEmpty
            ? 0
            : state.shops[event.shopId]!.reviews.length));

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          shopProductReviewStatus: ShopProductReviewStatus.failure)),
      (reviews) {
        if (reviews.isEmpty) {
          emit(state.copyWith(
              shopProductReviewStatus: ShopProductReviewStatus.loaded));
          return;
        }
        Map<String, ReviewEntity> newReviews = {
          ...state.shops[event.shopId]!.reviews,
        };
        for (var review in reviews) {
          newReviews[review.id] = review;
        }
        Map<String, ShopEntity> newShops = {...state.shops};
        newShops[event.shopId] = newShops[event.shopId]!.copyWith(
          reviews: newReviews,
        );
        emit(state.copyWith(
            shops: newShops,
            shopProductReviewStatus: ShopProductReviewStatus.success));
      },
    );
  }

  void _getShopWorkingHours(
    GetShopWorkingHoursEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (state.shops.containsKey(event.shopId)) {
      if (state.shops[event.shopId]?.workingHours.isNotEmpty ?? false) {
        return;
      }
    } else {
      return;
    }
    emit(state.copyWith(shopProductWorkStatus: ShopProductWorkStatus.loading));

    final result = await getShopWorkingHourUseCase(get_shop_working_hour.Params(
      shopId: event.shopId,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          shopProductWorkStatus: ShopProductWorkStatus.failure)),
      (workinghours) {
        List<WorkingHourEntity> newWorkingHours = [
          ...state.shops[event.shopId]!.workingHours,
          ...workinghours
        ];

        Map<String, ShopEntity> newShops = {...state.shops};
        newShops[event.shopId] = newShops[event.shopId]!.copyWith(
          workingHours: newWorkingHours,
        );

        emit(state.copyWith(
            shops: newShops,
            shopProductWorkStatus: ShopProductWorkStatus.loaded));
      },
    );
  }

  void _getMyShop(
    GetMyShopEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(shopMyProductsStatus: ShopMyProductsStatus.loading));
    final result = await getShopUseCase(get_shop.Params(
      token: event.token ?? '',
      ownerId: event.userId,
      skip: 0,
      limit: 10,
    ));
    result.fold(
        (failure) => emit(state.copyWith(
            errorMessage: failure.message,
            shopMyProductsStatus: ShopMyProductsStatus.failure)), (shops) {
      if (shops.isEmpty) {
        emit(
            state.copyWith(shopMyProductsStatus: ShopMyProductsStatus.failure));
        return;
      }

      Map<String, ShopEntity> shopMap = {...state.shops};
      shopMap[shops.first.id] = shops.first;

      emit(
        state.copyWith(
            shopMyProductsStatus: ShopMyProductsStatus.success,
            shops: shopMap,
            myShopId: shops.first.id),
      );
    });
  }

  void _addProduct(
    AddProductEvent event,
    Emitter<ShopState> emit,
  ) async {
    List<String> imagesBase64 = [];
    List<String> imagesIds = [];
    emit(state.copyWith(addProductStatus: AddProductStatus.loading));

    for (var image in event.fileImages) {
      final base64Image = await _getBase64Image(image);
      if (base64Image.isEmpty) {
        emit(state.copyWith(addProductStatus: AddProductStatus.failure));
        return;
      }
      final result = await addImageUseCase(add_image.Params(
        token: event.token,
        base64Image: base64Image,
      ));
      result.fold(
        (failure) {
          emit(state.copyWith(addProductStatus: AddProductStatus.failure));
          return;
        },
        (image) {
          imagesBase64.add(base64Image);
          imagesIds.add(image.id);
        },
      );
      if (state.addProductStatus == AddProductStatus.failure) {
        return;
      }
    }

    final result = await addProductsUseCase(add_product.Params(
      token: event.token,
      shopId: event.shopId,
      title: event.title,
      description: event.description,
      price: event.price,
      inStock: event.inStock,
      status: event.status,
      videoUrl: event.videoUrl,
      isNew: event.isNew,
      isDeliverable: event.isDeliverable,
      availableQuantity: event.availableQuantity,
      isNegotiable: event.isNegotiable,
      colorIds: event.colorIds,
      sizeIds: event.sizeIds,
      categoryIds: event.categoryIds,
      brandIds: event.brandIds,
      materialIds: event.materialIds,
      designIds: event.designIds,
      images: imagesIds + event.images.map((e) => e.id).toList(),
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
            errorMessage: failure.message,
            addProductStatus: AddProductStatus.failure));
      },
      (product) {
        Map<String, ShopEntity> newShops = {...state.shops};
        Map<String, ProductEntity> newProducts = {
          ...newShops[event.shopId]!.products
        };
        newProducts[product.id] = product;
        newShops[event.shopId] =
            newShops[event.shopId]!.copyWith(products: newProducts);

        Map<String, ProductEntity> newProductsMap = {...state.products};
        newProductsMap[product.id] = product;

        emit(state.copyWith(
          shops: newShops,
          addProductStatus: AddProductStatus.success,
        ));
      },
    );
  }

  Future<String> _getBase64Image(XFile image) async {
    final File imageFile = File(image.path);
    if (!imageFile.existsSync()) {
      return '';
    }
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String base64ImageWithPrefix = "data:image/png;base64,$base64Image";
    return base64ImageWithPrefix;
  }

  void _deleteProduct(
    DeleteProductEvent event,
    Emitter<ShopState> emit,
  ) async {
    final orginalState = state.copyWith();
    Map<String, ShopEntity> newShops = {...state.shops};
    Map<String, ProductEntity> newProducts = {
      ...newShops[event.product.shopInfo.id]!.products
    };
    Map<String, ProductEntity> newProductsMap = {...state.products};
    Map<String, ProductEntity> newfavoriteProducts = {
      ...state.favoriteProducts
    };
    Map<String, ProductEntity> archivedProducts = {...state.archiveProducts};
    Map<String, ProductEntity> draftProducts = {...state.draftProducts};
    bool inFavorite = state.favoriteProducts.containsKey(event.product.id);
    bool inProducts = state.products.containsKey(event.product.id);

    if (newProducts.containsKey(event.product.id)) {
      newProducts.remove(event.product.id);
    }
    if (inProducts) {
      newProductsMap.remove(event.product.id);
    }
    if (inFavorite) {
      newfavoriteProducts.remove(event.product.id);
    }

    if (archivedProducts.containsKey(event.product.id)) {
      archivedProducts.remove(event.product.id);
    }

    if (draftProducts.containsKey(event.product.id)) {
      draftProducts.remove(event.product.id);
    }

    newShops[event.product.shopInfo.id] =
        newShops[state.myShopId]!.copyWith(products: newProducts);

    emit(state.copyWith(
      shops: newShops,
      deleteProductStatus: DeleteProductStatus.loading,
      products: newProductsMap,
      favoriteProducts: newfavoriteProducts,
      archiveProducts: archivedProducts,
      draftProducts: draftProducts,
    ));

    final result = await deleteProductByIdUseCase(delete_product.Params(
      id: event.product.id,
      token: event.token,
    ));

    result.fold(
      (failure) {
        emit(
          orginalState.copyWith(
              errorMessage: failure.message,
              deleteProductStatus: DeleteProductStatus.failure),
        );
      },
      (product) {
        emit(state.copyWith(deleteProductStatus: DeleteProductStatus.success));
      },
    );
  }

  void _onGetFilteredProducts(
      GetFilteredProductsEvent event, Emitter<ShopState> emit) async {
    final newFilterParameter = ProductFilterParamter(
      search: event.search,
      colorIds: event.colorIds,
      sizeIds: event.sizeIds,
      categoryIds: event.categoryIds,
      brandIds: event.brandIds,
      designIds: event.designIds,
      isNew: event.isNew,
      isDeliverable: event.isDeliverable,
      inStock: event.inStock,
      isNegotiable: event.isNegotiable,
      materialIds: event.materialIds,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      latitudes: event.latitudes,
      longitudes: event.longitudes,
      radiusInKilometers: event.radiusInKilometers,
      condition: event.condition,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
    );

    bool isSame =
        state.productFilterParamter?.isObjectSame(newFilterParameter) ?? false;

    if (isSame) {
      emit(state.copyWith(
          filteredProductStatus: FilteredProductStatus.loadMore));
    } else {
      emit(state.copyWith(
          filteredProductStatus: FilteredProductStatus.loading,
          filteredProducts: []));
    }

    final result = await getProductsUseCase(
      product_usecase.Params(
        token: event.token,
        search: event.search,
        colorIds: event.colorIds,
        sizeIds: event.sizeIds,
        categoryIds: event.categoryIds,
        brandIds: event.brandIds,
        designIds: event.designIds,
        materialIds: event.materialIds,
        isNegotiable: event.isNegotiable,
        isNew: event.isNew,
        isDeliverable: event.isDeliverable,
        inStock: event.inStock,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        latitudes: event.latitudes,
        longitudes: event.longitudes,
        radiusInKilometers: event.radiusInKilometers,
        condition: event.condition,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        skip: isSame ? state.filteredProducts.length : 0,
        limit: 20,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          filteredProductStatus: FilteredProductStatus.failure)),
      (products) => emit(state.copyWith(
          filteredProducts: [...state.filteredProducts, ...products],
          filteredProductStatus: FilteredProductStatus.success,
          productFilterParamter: newFilterParameter)),
    );
  }

  void _onGetProducts(GetProductsEvent event, Emitter<ShopState> emit) async {
    if (state.homePageTabIndex == event.homePageTabIndex &&
        state.mainProductStatus == MainProductsStatus.loaded) {
      return;
    }

    if (state.homePageTabIndex == event.homePageTabIndex) {
      emit(state.copyWith(mainProductStatus: MainProductsStatus.loadMore));
    } else {
      emit(state.copyWith(
        mainProductStatus: MainProductsStatus.loading,
        products: {},
      ));
    }

    final result = await getProductsUseCase(
      product_usecase.Params(
          token: event.token,
          search: event.search,
          colorIds: event.colorIds,
          sizeIds: event.sizeIds,
          categoryIds: event.categoryIds,
          brandIds: event.brandIds,
          designIds: event.designIds,
          materialIds: event.materialIds,
          isNegotiable: event.isNegotiable,
          isNew: event.isNew,
          isDeliverable: event.isDeliverable,
          inStock: event.inStock,
          minPrice: event.minPrice,
          maxPrice: event.maxPrice,
          latitudes: event.latitudes,
          longitudes: event.longitudes,
          radiusInKilometers: event.radiusInKilometers,
          condition: event.condition,
          sortBy: event.sortBy,
          sortOrder: event.sortOrder,
          skip: state.homePageTabIndex == event.homePageTabIndex
              ? state.products.length
              : 0,
          limit: 20),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
        mainProductStatus: MainProductsStatus.failure,
        homePageTabIndex: event.homePageTabIndex,
      )),
      (products) {
        if (products.isEmpty) {
          emit(state.copyWith(mainProductStatus: MainProductsStatus.loaded));
          return;
        }
        Map<String, ProductEntity> newProducts = {...state.products};
        for (var product in products) {
          newProducts[product.id] = product;
        }
        emit(state.copyWith(
          products: newProducts,
          mainProductStatus: MainProductsStatus.success,
          homePageTabIndex: event.homePageTabIndex,
        ));
      },
    );
  }

  void _getFavoriteProducts(
      GetFavoriteProductsEvent event, Emitter<ShopState> emit) async {
    if (state.favoriteProductsStatus == FavoriteProductsStatus.loaded) {
      return;
    }

    if (state.favoriteProducts.values.isNotEmpty) {
      emit(state.copyWith(
          favoriteProductsStatus: FavoriteProductsStatus.loadMore));
    } else {
      emit(state.copyWith(
          favoriteProductsStatus: FavoriteProductsStatus.loading));
    }

    final result = await getFavoriteUseCase(get_favorite.Params(
      token: event.token,
      skip: state.favoriteProducts.isEmpty ? 0 : state.favoriteProducts.length,
      limit: 10,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          favoriteProductsStatus: FavoriteProductsStatus.failure)),
      (products) {
        if (products.isEmpty) {
          emit(state.copyWith(
              favoriteProductsStatus: FavoriteProductsStatus.loaded));
          return;
        }
        Map<String, ProductEntity> newFavoriteProducts = {
          ...state.favoriteProducts
        };
        for (var product in products) {
          newFavoriteProducts[product.id] = product;
        }
        emit(state.copyWith(
          favoriteProducts: newFavoriteProducts,
          favoriteProductsStatus: FavoriteProductsStatus.success,
        ));
      },
    );
  }

  void _addOrRemoveFavoriteProduct(
      AddOrRemoveFavoriteProductEvent event, Emitter<ShopState> emit) async {
    if (event.product.isFavorite) {
      Map<String, ShopEntity> newShops = {...state.shops};
      for (var shop in newShops.values) {
        Map<String, ProductEntity> newProducts = {...shop.products};
        if (newProducts.containsKey(event.product.id)) {
          newProducts[event.product.id] =
              newProducts[event.product.id]!.copyWith(isFavorite: false);
        }
        newShops[shop.id] = shop.copyWith(products: newProducts);
      }
      emit(
        state.copyWith(
          addProductStatus: AddProductStatus.loading,
          favoriteProducts: {
            ...state.favoriteProducts,
            event.product.id: event.product.copyWith(isFavorite: false)
          },
          products: {
            ...state.products,
            event.product.id: event.product.copyWith(isFavorite: false)
          },
          shops: newShops,
        ),
      );
    } else {
      Map<String, ShopEntity> newShops = {...state.shops};
      for (var shop in newShops.values) {
        Map<String, ProductEntity> newProducts = {...shop.products};
        if (newProducts.containsKey(event.product.id)) {
          newProducts[event.product.id] =
              newProducts[event.product.id]!.copyWith(isFavorite: true);
        }
        newShops[shop.id] = shop.copyWith(products: newProducts);
      }

      emit(
        state.copyWith(
          addProductStatus: AddProductStatus.loading,
          favoriteProducts: {
            ...state.favoriteProducts,
            event.product.id: event.product.copyWith(isFavorite: true)
          },
          products: {
            ...state.products,
            event.product.id: event.product.copyWith(isFavorite: true)
          },
          shops: newShops,
        ),
      );
    }

    final result = await addOrRemoveFavoriteUseCase(
        add_or_remove_favorite.Params(
            token: event.token, productId: event.product.id));

    result.fold(
      (failure) {
        if (event.product.isFavorite) {
          Map<String, ShopEntity> newShops = {...state.shops};
          for (var shop in newShops.values) {
            Map<String, ProductEntity> newProducts = {...shop.products};
            if (newProducts.containsKey(event.product.id)) {
              newProducts[event.product.id] =
                  newProducts[event.product.id]!.copyWith(isFavorite: true);
            }
            newShops[shop.id] = shop.copyWith(products: newProducts);
          }
          emit(
            state.copyWith(
              errorMessage: failure.message,
              addProductStatus: AddProductStatus.failure,
              favoriteProducts: {
                ...state.favoriteProducts,
                event.product.id: event.product.copyWith(isFavorite: true)
              },
              products: {
                ...state.products,
                event.product.id: event.product.copyWith(isFavorite: true)
              },
              shops: newShops,
            ),
          );
        } else {
          Map<String, ShopEntity> newShops = {...state.shops};
          for (var shop in newShops.values) {
            Map<String, ProductEntity> newProducts = {...shop.products};
            if (newProducts.containsKey(event.product.id)) {
              newProducts[event.product.id] =
                  newProducts[event.product.id]!.copyWith(isFavorite: false);
            }
            newShops[shop.id] = shop.copyWith(products: newProducts);
          }

          emit(
            state.copyWith(
              errorMessage: failure.message,
              addProductStatus: AddProductStatus.failure,
              favoriteProducts: {
                ...state.favoriteProducts,
                event.product.id: event.product.copyWith(isFavorite: false)
              },
              products: {
                ...state.products,
                event.product.id: event.product.copyWith(isFavorite: false)
              },
              shops: newShops,
            ),
          );
        }
      },
      (data) {
        emit(state.copyWith(addProductStatus: AddProductStatus.success));
      },
    );
  }

  void _getArchiveProducts(
    GetArchivedProductsEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (state.listArchiveProductsStatus == ListArchiveProductsStatus.loaded) {
      return;
    }

    if (state.archiveProducts.isNotEmpty) {
      emit(state.copyWith(
        listArchiveProductsStatus: ListArchiveProductsStatus.loadMore,
      ));
    } else {
      emit(state.copyWith(
        listArchiveProductsStatus: ListArchiveProductsStatus.loading,
      ));
    }

    final result = await getProductsUseCase(
      product_usecase.Params(
        token: event.token,
        status: 'archive',
        skip: state.archiveProducts.isEmpty ? 0 : state.archiveProducts.length,
        limit: 10,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          listArchiveProductsStatus: ListArchiveProductsStatus.failure)),
      (products) {
        if (products.isEmpty) {
          emit(state.copyWith(
              listArchiveProductsStatus: ListArchiveProductsStatus.loaded));
          return;
        }
        Map<String, ProductEntity> newArchiveProducts = {
          ...state.archiveProducts
        };
        for (var product in products) {
          newArchiveProducts[product.id] = product;
        }
        emit(state.copyWith(
          archiveProducts: newArchiveProducts,
          listArchiveProductsStatus: ListArchiveProductsStatus.success,
        ));
      },
    );
  }

  void _getDraftProducts(
    GetDraftProductsEvent event,
    Emitter<ShopState> emit,
  ) async {
    if (state.listDraftProductsStatus == ListDraftProductsStatus.loaded) {
      return;
    }

    if (state.draftProducts.isNotEmpty) {
      emit(state.copyWith(
        listDraftProductsStatus: ListDraftProductsStatus.loadMore,
      ));
    } else {
      emit(state.copyWith(
        listDraftProductsStatus: ListDraftProductsStatus.loading,
      ));
    }

    final result = await getProductsUseCase(
      product_usecase.Params(
        token: event.token,
        status: 'draft',
        skip: state.draftProducts.isEmpty ? 0 : state.draftProducts.length,
        limit: 10,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          listDraftProductsStatus: ListDraftProductsStatus.failure)),
      (products) {
        if (products.isEmpty) {
          emit(state.copyWith(
              listDraftProductsStatus: ListDraftProductsStatus.loaded));
          return;
        }
        Map<String, ProductEntity> newDraftProducts = {...state.draftProducts};
        for (var product in products) {
          newDraftProducts[product.id] = product;
        }
        emit(state.copyWith(
          draftProducts: newDraftProducts,
          listDraftProductsStatus: ListDraftProductsStatus.success,
        ));
      },
    );
  }

  void _updateProduct(
    UpdateProductEvent event,
    Emitter<ShopState> emit,
  ) async {
    List<String> imagesBase64 = [];
    List<String> imagesIds = [];
    emit(state.copyWith(updateProductStatus: UpdateProductStatus.loading));

    for (var image in event.fileImages) {
      final base64Image = await _getBase64Image(image);
      if (base64Image.isEmpty) {
        emit(state.copyWith(addProductStatus: AddProductStatus.failure));
        return;
      }
      final result = await addImageUseCase(add_image.Params(
        token: event.token,
        base64Image: base64Image,
      ));
      result.fold(
        (failure) {
          emit(state.copyWith(
              errorMessage: failure.message,
              addProductStatus: AddProductStatus.failure));
          return;
        },
        (image) {
          imagesBase64.add(base64Image);
          imagesIds.add(image.id);
        },
      );
      if (state.addProductStatus == AddProductStatus.failure) {
        return;
      }
    }

    Map<String, ShopEntity> newShops = {...state.shops};
    Map<String, ProductEntity> newDraftProducts = {...state.draftProducts};
    bool inFavorite = state.favoriteProducts.containsKey(event.id);
    bool inProducts = state.products.containsKey(event.id);
    Map<String, ProductEntity> newFavoriteProducts = {
      ...state.favoriteProducts
    };
    Map<String, ProductEntity> newProducts = {...state.products};

    if (inFavorite) {
      newFavoriteProducts.remove(event.id);
    }
    if (inProducts) {
      newProducts.remove(event.id);
    }
    newShops[event.shopId]!.products.remove(event.id);
    if (newDraftProducts.containsKey(event.id)) {
      newDraftProducts.remove(event.id);
    }

    emit(state.copyWith(
      updateProductStatus: UpdateProductStatus.loading,
      favoriteProducts: newFavoriteProducts,
      products: newProducts,
      draftProducts: newDraftProducts,
      shops: newShops,
    ));

    final result = await updateProductsUseCase(update_product.Params(
      id: event.id,
      token: event.token,
      shopId: event.shopId,
      title: event.title,
      description: event.description,
      price: event.price,
      inStock: event.inStock,
      isNegotiable: event.isNegotiable,
      isDeliverable: event.isDeliverable,
      availableQuantity: event.availableQuantity,
      isNew: event.isNew,
      status: event.status,
      videoUrl: event.videoUrl,
      colorIds: event.colorIds,
      sizeIds: event.sizeIds,
      categoryIds: event.categoryIds,
      brandIds: event.brandIds,
      materialIds: event.materialIds,
      designIds: event.designIds,
      images: imagesIds + event.images.map((e) => e.id).toList(),
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
            errorMessage: failure.message,
            updateProductStatus: UpdateProductStatus.failure));
      },
      (product) {
        if (event.status == 'draft') {
          emit(state.copyWith(
            products: newProducts,
            favoriteProducts: newFavoriteProducts,
            shops: newShops,
            draftProducts: {
              ...state.draftProducts,
              product.id: product,
            },
            updateProductStatus: UpdateProductStatus.success,
          ));
        } else {
          if (inFavorite) {
            newFavoriteProducts[event.id] = product;
          }
          if (inProducts) {
            newProducts[event.id] = product;
          }
          newShops[event.shopId]!.products[event.id] = product;
          emit(state.copyWith(
            products: newProducts,
            favoriteProducts: newFavoriteProducts,
            shops: newShops,
            updateProductStatus: UpdateProductStatus.success,
          ));
        }
      },
    );
  }

  void _archiveProduct(
    ArchiveProductEvent event,
    Emitter<ShopState> emit,
  ) async {
    final isInFavorite = state.favoriteProducts.containsKey(event.product.id);
    final isInProducts = state.products.containsKey(event.product.id);

    Map<String, ProductEntity> newFavoriteProducts = {
      ...state.favoriteProducts
    };
    Map<String, ProductEntity> newProducts = {...state.products};
    Map<String, ShopEntity> newShops = {...state.shops};

    if (isInFavorite) {
      newFavoriteProducts.remove(event.product.id);
    }

    if (isInProducts) {
      newProducts.remove(event.product.id);
    }

    newShops[event.product.shopInfo.id]?.products.remove(event.product.id);

    emit(state.copyWith(
      favoriteProducts: newFavoriteProducts,
      products: newProducts,
      shops: newShops,
      archiveProductsStatus: ArchiveProductsStatus.loading,
      archiveProducts: {
        ...state.archiveProducts,
        event.product.id: event.product.copyWith(status: 'archive'),
      },
    ));

    final result = await updateProductsUseCase(update_product.Params(
      id: event.product.id,
      token: event.token,
      status: 'archive',
    ));

    result.fold(
      (failure) {
        if (isInFavorite) {
          newFavoriteProducts[event.product.id] =
              event.product.copyWith(status: 'active');
        }
        if (isInProducts) {
          newProducts[event.product.id] =
              event.product.copyWith(status: 'active');
        }
        newShops[event.product.shopInfo.id]?.products[event.product.id] =
            event.product.copyWith(status: 'active');

        emit(state.copyWith(
          errorMessage: failure.message,
          favoriteProducts: newFavoriteProducts,
          products: newProducts,
          shops: newShops,
          archiveProductsStatus: ArchiveProductsStatus.failure,
        ));
      },
      (product) {
        emit(state.copyWith(
          archiveProductsStatus: ArchiveProductsStatus.success,
        ));
      },
    );
  }

  void _unArchiveProduct(
    UnArchiveProductEvent event,
    Emitter<ShopState> emit,
  ) async {
    final shopArchiveProducts = {...state.archiveProducts};
    final newShopArchiveProducts = {...shopArchiveProducts};
    newShopArchiveProducts.remove(event.product.id);

    final newShop = {
      ...state.shops,
      event.product.shopInfo.id:
          state.shops[event.product.shopInfo.id]!.copyWith(
        products: {
          ...state.shops[event.product.shopInfo.id]!.products,
          event.product.id: event.product.copyWith(status: 'active'),
        },
      ),
    };

    emit(state.copyWith(
      archiveProducts: newShopArchiveProducts,
      shops: newShop,
    ));

    final result = await updateProductsUseCase(update_product.Params(
      id: event.product.id,
      token: event.token,
      status: 'active',
    ));

    result.fold(
      (failure) {
        final revertedShop = {
          ...state.shops,
          event.product.shopInfo.id:
              state.shops[event.product.shopInfo.id]!.copyWith(
            products: {
              ...state.shops[event.product.shopInfo.id]!.products,
              event.product.id: event.product.copyWith(status: 'archive'),
            },
          ),
        };

        emit(state.copyWith(
          errorMessage: failure.message,
          archiveProducts: shopArchiveProducts,
          shops: revertedShop,
          archiveProductsStatus: ArchiveProductsStatus.failure,
        ));
      },
      (product) {
        emit(state.copyWith(
          archiveProductsStatus: ArchiveProductsStatus.success,
        ));
      },
    );
  }

  void _draftProduct(
    DraftProductEvent event,
    Emitter<ShopState> emit,
  ) async {
    final isInFavorite = state.favoriteProducts.containsKey(event.product.id);
    final isInProducts = state.products.containsKey(event.product.id);

    Map<String, ProductEntity> newFavoriteProducts = {
      ...state.favoriteProducts
    };
    Map<String, ProductEntity> newProducts = {...state.products};
    Map<String, ShopEntity> newShops = {...state.shops};
    if (isInFavorite) {
      newFavoriteProducts.remove(event.product.id);
    }

    if (isInProducts) {
      newProducts.remove(event.product.id);
    }
    newShops[event.product.shopInfo.id]?.products.remove(event.product.id);

    emit(state.copyWith(
      favoriteProducts: newFavoriteProducts,
      products: newProducts,
      shops: newShops,
      draftProductsStatus: DraftProductsStatus.loading,
      draftProducts: {
        ...state.draftProducts,
        event.product.id: event.product.copyWith(status: 'draft'),
      },
    ));

    final result = await updateProductsUseCase(update_product.Params(
      id: event.product.id,
      token: event.token,
      status: 'draft',
    ));

    result.fold(
      (failure) {
        if (isInFavorite) {
          newFavoriteProducts[event.product.id] =
              event.product.copyWith(status: 'active');
        }
        if (isInProducts) {
          newProducts[event.product.id] =
              event.product.copyWith(status: 'active');
        }
        newShops[event.product.shopInfo.id]?.products[event.product.id] =
            event.product.copyWith(status: 'active');

        emit(state.copyWith(
          errorMessage: failure.message,
          favoriteProducts: newFavoriteProducts,
          products: newProducts,
          shops: newShops,
          draftProductsStatus: DraftProductsStatus.failure,
        ));
      },
      (product) {
        emit(state.copyWith(
          draftProductsStatus: DraftProductsStatus.success,
        ));
      },
    );
  }

  void _unDraftProduct(
    UnDraftProductEvent event,
    Emitter<ShopState> emit,
  ) async {
    Map<String, ProductEntity> newDraftProducts = {...state.draftProducts};
    Map<String, ShopEntity> newShops = {...state.shops};

    newDraftProducts.remove(event.product.id);

    newShops[event.product.shopInfo.id] =
        state.shops[event.product.shopInfo.id]!.copyWith(
      products: {
        ...state.shops[event.product.shopInfo.id]!.products,
        event.product.id: event.product.copyWith(status: 'active'),
      },
    );
    emit(state.copyWith(
      draftProducts: newDraftProducts,
      shops: newShops,
      draftProductsStatus: DraftProductsStatus.loading,
    ));

    final result = await updateProductsUseCase(update_product.Params(
      id: event.product.id,
      token: event.token,
      status: 'active',
    ));

    result.fold(
      (failure) {
        newDraftProducts[event.product.id] =
            event.product.copyWith(status: 'draft');
        newShops[event.product.shopInfo.id] =
            state.shops[event.product.shopInfo.id]!.copyWith(
          products: {
            ...state.shops[event.product.shopInfo.id]!.products,
            event.product.id: event.product.copyWith(status: 'draft'),
          },
        );

        emit(state.copyWith(
          errorMessage: failure.message,
          draftProducts: newDraftProducts,
          shops: newShops,
          draftProductsStatus: DraftProductsStatus.failure,
        ));
      },
      (product) {
        emit(state.copyWith(
          draftProductsStatus: DraftProductsStatus.success,
        ));
      },
    );
  }

  void _addReview(
    AddReviewEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(addReviewStatus: AddReviewStatus.loading));

    final result = await addReviewUseCase(add_review.Params(
      token: event.token,
      shopId: event.shopId,
      rating: event.rating,
      review: event.review,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
            addReviewStatus: AddReviewStatus.failure,
            errorMessage: failure.message));
      },
      (review) {
        Map<String, ShopEntity> newShops = {...state.shops};
        Map<String, ReviewEntity> newReviews = {
          review.id: review,
          ...newShops[event.shopId]!.reviews,
        };

        newShops[event.shopId] = newShops[event.shopId]!.copyWith(
          reviews: newReviews,
        );

        emit(state.copyWith(
          shops: newShops,
          addReviewStatus: AddReviewStatus.success,
        ));
      },
    );
  }

  void _updateReview(
    UpdateReviewEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(updateReviewStatus: UpdateReviewStatus.loading));

    final result = await updateReviewUseCase(update_review.Params(
      reviewId: event.reviewId,
      token: event.token,
      rating: event.rating,
      review: event.review,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
            updateReviewStatus: UpdateReviewStatus.failure,
            errorMessage: failure.message));
      },
      (review) {
        Map<String, ShopEntity> newShops = {...state.shops};
        Map<String, ReviewEntity> newReviews = {
          ...newShops[event.shopId]!.reviews,
          review.id: review,
        };

        newShops[event.shopId] = newShops[event.shopId]!.copyWith(
          reviews: newReviews,
        );

        emit(state.copyWith(
          shops: newShops,
          updateReviewStatus: UpdateReviewStatus.success,
        ));
      },
    );
  }

  void _deleteReview(
    DeleteReviewEvent event,
    Emitter<ShopState> emit,
  ) async {
    Map<String, ShopEntity> newShops = {...state.shops};
    Map<String, ReviewEntity> newReviews = {
      ...newShops[event.review.shopId]!.reviews
    };
    newReviews.remove(event.review.id);
    newShops[event.review.shopId] =
        newShops[event.review.shopId]!.copyWith(reviews: newReviews);

    emit(state.copyWith(
      shops: newShops,
      deleteReviewStatus: DeleteReviewStatus.loading,
    ));

    final result = await deleteReviewUseCase(delete_review.Params(
      id: event.review.id,
      token: event.token,
    ));

    result.fold(
      (failure) {
        newReviews[event.review.id] = event.review;
        newShops[event.review.shopId] = newShops[event.review.shopId]!.copyWith(
          reviews: newReviews,
        );

        emit(state.copyWith(
          shops: newShops,
          deleteReviewStatus: DeleteReviewStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          deleteReviewStatus: DeleteReviewStatus.success,
        ));
      },
    );
  }

  void _getShopAnalytic(
    GetShopAnalyticEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(shopAnalyticsStatus: ShopAnalyticsStatus.loading));

    final result = await shopAnalyticUseCase(
        shop_analytic.Params(token: event.token, id: event.id));

    result.fold(
      (failure) {
        emit(state.copyWith(
          shopAnalyticsStatus: ShopAnalyticsStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (analytics) {
        final updatedEntity = state.analyticShopEntity.copyWith(
          totalContacts: analytics.totalContacts,
          totalFavorites: analytics.totalFavorites,
          totalFollowers: analytics.totalFollowers,
          totalProducts: analytics.totalProducts,
          totalReviews: analytics.totalReviews,
          totalViews: analytics.totalViews,
          oneStarReviews: analytics.oneStarReviews,
          twoStarReviews: analytics.twoStarReviews,
          threeStarReviews: analytics.threeStarReviews,
          fourStarReviews: analytics.fourStarReviews,
          fiveStarReviews: analytics.fiveStarReviews,
        );

        emit(state.copyWith(
          shopAnalyticsStatus: ShopAnalyticsStatus.success,
          analyticShopEntity: updatedEntity,
        ));
      },
    );
  }

  Future<String> _getBase64ImageFromFile(File image) async {
    final File imageFile = File(image.path);
    if (!imageFile.existsSync()) {
      return '';
    }
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String base64ImageWithPrefix = "data:image/png;base64,$base64Image";
    return base64ImageWithPrefix;
  }

  void _createShop(
    CreateShopEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(createShopStatus: CreateShopStatus.loading));
    bool isSuccessed = false;
    List<WorkingHourEntity> newWorkingHour = [];

    final result = await createShopUseCase(create_shop.Params(
      token: event.token,
      name: event.name,
      description: event.description,
      street: event.address.street,
      subLocality: event.address.subLocality,
      subAdministrativeArea: event.address.subAdministrativeArea,
      postalCode: event.address.postalCode,
      latitude: event.latitude,
      longitude: event.longitude,
      phone: event.phone,
      website: event.website,
      logo: await _getBase64ImageFromFile(event.logo),
      categories: event.categories,
      socialMedia: event.socialMedia,
    ));
    result.fold(
      (failure) {
        emit(state.copyWith(
          createShopStatus: CreateShopStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (shop) {
        isSuccessed = true;

        emit(state.copyWith(
          myShopId: shop.id,
          shops: {...state.shops, shop.id: shop},
        ));
      },
    );

    if (isSuccessed) {
      for (var workingHour in event.workingHours.entries) {
        final workingHourResult = await addWorkingHourUseCase(
          add_working_hour.Params(
            token: event.token,
            shopId: state.myShopId!,
            day: workingHour.key.toLowerCase(),
            time: workingHour.value,
          ),
        );
        workingHourResult.fold(
          (failure) {},
          (data) {
            newWorkingHour.add(data);
          },
        );
      }
      final newShop =
          state.shops[state.myShopId!]!.copyWith(workingHours: newWorkingHour);
      emit(state.copyWith(
        shops: {
          state.myShopId!: newShop,
          ...state.shops,
        },
        createShopStatus: CreateShopStatus.success,
        shopMyProductsStatus: ShopMyProductsStatus.success,
        deleteShopStatus: DeleteShopStatus.initial,
        shopStatus: ShopStatus.success,
      ));
    }
  }

  void _searchShop(SearchShopEvent event, Emitter<ShopState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
          searchResult: const [],
          searchQuery: '',
          shopSearchStatus: ShopSearchStatus.initial));
      return;
    }
    if (event.query == state.searchQuery) {
      emit(state.copyWith(shopSearchStatus: ShopSearchStatus.loadMore));
    } else {
      emit(state.copyWith(
          shopSearchStatus: ShopSearchStatus.loading, searchResult: []));
    }
    final result = await getShopUseCase(get_shop.Params(
      token: '',
      search: event.query,
      skip: event.query == state.searchQuery ? state.searchResult.length : 0,
      limit: 35,
    ));
    result.fold(
        (failure) =>
            emit(state.copyWith(shopSearchStatus: ShopSearchStatus.failure)),
        (shops) {
      if (shops.isEmpty) {
        emit(state.copyWith(shopSearchStatus: ShopSearchStatus.noMore));
        return;
      }
      emit(state.copyWith(
        shopSearchStatus: ShopSearchStatus.success,
        searchResult: event.query == state.searchQuery
            ? [...state.searchResult, ...shops]
            : shops,
        searchQuery: event.query,
      ));
    });
  }

  void _shopImageUpload(
    ShopImageUploadEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(shopImageUploadStatus: ShopImageUploadStatus.loading));

    final result = await updateShopUseCase(update_shop.Params(
      token: event.token,
      id: state.myShopId ?? '',
      logo: event.isLogo ? await _getBase64ImageFromFile(event.image) : null,
      banner: event.isLogo ? null : await _getBase64ImageFromFile(event.image),
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
          shopImageUploadStatus: ShopImageUploadStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (image) {
        final newShops = {...state.shops};
        newShops[state.myShopId!] = newShops[state.myShopId!]!.copyWith(
          logo: image.logo,
          banner: image.banner,
        );
        emit(state.copyWith(
          shopImageUploadStatus: ShopImageUploadStatus.success,
          shops: newShops,
        ));
      },
    );
  }

  void _updateShop(
    UpdateShopEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(updateShopStatus: UpdateShopStatus.loading));

    final result = await updateShopUseCase(update_shop.Params(
      token: event.token,
      id: state.myShopId ?? '',
      name: event.name,
      description: event.description,
      street: event.street,
      subLocality: event.subLocality,
      subAdministrativeArea: event.subAdministrativeArea,
      postalCode: event.postalCode,
      latitude: event.latitude,
      longitude: event.longitude,
      phone: event.phone,
      website: event.website,
      categories: event.categories,
      socialMedia: event.socialMedia,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
          updateShopStatus: UpdateShopStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (shop) {
        final newShops = {...state.shops};
        newShops[state.myShopId!] = shop;
        emit(state.copyWith(
          updateShopStatus: UpdateShopStatus.success,
          shops: newShops,
        ));
      },
    );
  }

  void _updateShopWorkingHour(
    UpdateShopWorkingHourEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(
        updateShopWorkingHourStatus: UpdateShopWorkingHourStatus.loading));

    for (var workingHour in event.workingHours) {
      final workingHourResult = await updateWorkingHourUseCase(
        update_working_hour.Params(
            token: event.token,
            id: workingHour.id,
            day: workingHour.day.toLowerCase(),
            time: workingHour.time),
      );
      workingHourResult.fold(
        (failure) {
          emit(state.copyWith(
            updateShopWorkingHourStatus: UpdateShopWorkingHourStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (data) {
          final newShopWorkingHours = state.shops[state.myShopId]!.workingHours;
          for (int i = 0; i < newShopWorkingHours.length; i++) {
            if (newShopWorkingHours[i].id == workingHour.id) {
              newShopWorkingHours[i] = workingHour;
              break;
            }
          }
          emit(state.copyWith(
            shops: {
              ...state.shops,
              state.myShopId!: state.shops[state.myShopId]!.copyWith(
                workingHours: newShopWorkingHours,
              ),
            },
          ));
        },
      );

      if (state.updateShopWorkingHourStatus ==
          UpdateShopWorkingHourStatus.failure) {
        return;
      }
    }

    emit(state.copyWith(
      updateShopWorkingHourStatus: UpdateShopWorkingHourStatus.success,
    ));
  }

  void _deleteShop(
    DeleteShopEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(deleteShopStatus: DeleteShopStatus.loading));

    final result = await deleteShopUseCase(delete_shop.Params(
      id: event.id,
      token: event.token,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
          deleteShopStatus: DeleteShopStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        Map<String, ShopEntity> newShops = {};
        for (var shop in state.shops.entries) {
          if (shop.key != data.id) {
            newShops[shop.key] = shop.value;
          }
        }

        Map<String, ProductEntity> products = {};
        for (var shop in state.products.entries) {
          if (shop.value.shopInfo.id != data.id) {
            products[shop.key] = shop.value;
          }
        }

        Map<String, ProductEntity> favoriteProducts = {};
        for (var shop in state.favoriteProducts.entries) {
          if (shop.value.shopInfo.id != data.id) {
            favoriteProducts[shop.key] = shop.value;
          }
        }

        emit(state.copyWith(
          deleteShopStatus: DeleteShopStatus.success,
          myShopId: null,
          shops: newShops,
          archiveProducts: {},
          draftProducts: {},
          archiveProductsStatus: ArchiveProductsStatus.initial,
          draftProductsStatus: DraftProductsStatus.initial,
          analyticShopEntity: null,
          shopMyProductsStatus: ShopMyProductsStatus.initial,
          shopAnalyticsStatus: ShopAnalyticsStatus.initial,
          products: products,
          shopStatus: ShopStatus.initial,
          favoriteProducts: favoriteProducts,
        ));
      },
    );
  }

  void _getProductAnalytic(
    GetProductAnalyticEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(productAnalyticStatus: ProductAnalyticStatus.loading));

    final result = await productAnalyticUseCase(
      product_analytic.Params(
        token: event.token,
        id: event.id,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          productAnalyticStatus: ProductAnalyticStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (analytic) {
        emit(state.copyWith(
          productAnalyticStatus: ProductAnalyticStatus.success,
          analyticProductEntity: analytic,
        ));
      },
    );
  }

  void _followOrUnFollowShop(
    FollowOrUnFollowShopEvent event,
    Emitter<ShopState> emit,
  ) async {
    final shop = state.shops[event.shopId];
    final isFollowing = shop!.isFollowing;
    final newShop = shop.copyWith(isFollowing: !isFollowing);

    emit(state.copyWith(
      shops: {
        ...state.shops,
        event.shopId: newShop,
      },
    ));

    final result = await followUnfollowShopUseCase(
      follow_unfollow_shop.FollowUnfollowShopParams(
        token: event.token,
        shopId: event.shopId,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          errorMessage: failure.message,
          shops: {
            ...state.shops,
            event.shopId: shop.copyWith(isFollowing: isFollowing),
          },
        ));
      },
      (data) {},
    );
  }

  void _makeContact(MakeContactEvent event, Emitter<ShopState> emit) async {
    final result = await makeContactUseCase(
      make_contact.Params(
        token: event.token,
        id: event.productId,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          errorMessage: failure.message,
        ));
      },
      (data) {},
    );
  }

  void _getFollowingShopProducts(
      GetFollowingShopProductsEvent event, Emitter<ShopState> emit) async {
    if (state.homePageTabIndex == event.homePageTabIndex) {
      emit(state.copyWith(mainProductStatus: MainProductsStatus.loadMore));
    } else {
      emit(state.copyWith(
        mainProductStatus: MainProductsStatus.loading,
        products: {},
      ));
    }

    final result = await getFollowingShopProductsUseCase(
      get_following_shop_products.Params(
        token: event.token,
        skip: state.homePageTabIndex == event.homePageTabIndex
            ? state.products.length
            : 0,
        limit: 20,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message,
          mainProductStatus: MainProductsStatus.failure)),
      (products) {
        Map<String, ProductEntity> newProducts = {...state.products};
        for (var product in products) {
          newProducts[product.id] = product;
        }
        emit(state.copyWith(
          products: newProducts,
          mainProductStatus: MainProductsStatus.success,
          homePageTabIndex: event.homePageTabIndex,
        ));
      },
    );
  }

  void _shopVerificationRequest(
      ShopVerificationRequestEvent event, Emitter<ShopState> emit) {}

  void _requestShopVerification(
      RequestShopVerificationEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(
        requestShopVerificationStatus: RequestShopVerificationStatus.loading));

    final result = await shopVerificationRequestUseCase(
      shop_verification_request.Params(
        token: event.token,
        id: event.id,
        ownerIdentityCardUrl: event.ownerIdentityCardUrl,
        businessRegistrationDocumentUrl: event.businessRegistrationDocumentUrl,
        businessRegistrationNumber: event.businessRegistrationNumber,
        ownerSelfieUrl: event.ownerSelfieUrl,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          requestShopVerificationStatus: RequestShopVerificationStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        final newShop = state.shops[event.id]!.copyWith(
          verificationStatus: data.verificationStatus,
        );
        emit(state.copyWith(
          shops: {
            ...state.shops,
            event.id: newShop,
          },
          requestShopVerificationStatus: RequestShopVerificationStatus.success,
        ));
      },
    );
  }
}
