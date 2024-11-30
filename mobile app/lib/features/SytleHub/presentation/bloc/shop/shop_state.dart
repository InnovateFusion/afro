part of 'shop_bloc.dart';

enum ShopProductsStatus { initial, loading, loadMore, success, failure, loaded }

enum ShopStatus { initial, loading, success, failure, loaded }

enum ShopProductStatus { initial, loading, success, failure, loaded }

enum ShopProductReviewStatus {
  initial,
  loading,
  loadMore,
  success,
  failure,
  loaded
}

enum ShopProductImageStatus {
  initial,
  loading,
  loadMore,
  success,
  failure,
  loaded
}

enum ShopProductVideoStatus { initial, loading, success, failure, loaded }

enum ShopProductWorkStatus { initial, loading, success, failure, loaded }

enum ShopsListStatus { initial, loading, loadMore, success, failure, loaded }

enum ShopMyProductsStatus { initial, loading, success, failure, loaded }

enum DeleteProductStatus { initial, loading, success, failure, loaded }

enum AddProductStatus { initial, loading, success, failure, loaded }

enum FilteredProductStatus {
  initial,
  loading,
  loadMore,
  success,
  failure,
  loaded
}

enum MainProductsStatus { initial, loading, loadMore, success, failure, loaded }

enum FavoriteProductsStatus {
  initial,
  loading,
  loadMore,
  success,
  failure,
  loaded
}

enum UpdateProductStatus { initial, loading, success, failure, loaded }

enum ListArchiveProductsStatus {
  initial,
  loading,
  loadMore,
  success,
  failure,
  loaded
}

enum ListDraftProductsStatus {
  initial,
  loading,
  loadMore,
  success,
  failure,
  loaded
}

enum ArchiveProductsStatus { initial, loading, success, failure, loaded }

enum DraftProductsStatus { initial, loading, success, failure, loaded }

enum UnArchiveProductsStatus { initial, loading, success, failure, loaded }

enum UnDraftProductsStatus { initial, loading, success, failure, loaded }

enum AddReviewStatus { initial, loading, success, failure, loaded }

enum UpdateReviewStatus { initial, loading, success, failure, loaded }

enum DeleteReviewStatus { initial, loading, success, failure, loaded }

enum ShopAnalyticsStatus { initial, loading, success, failure, loaded }

enum CreateShopStatus { initial, loading, success, failure, loaded }

enum ShopSearchStatus { initial, loading, success, failure, noMore, loadMore }

enum ShopImageUploadStatus { initial, loading, success, failure }

enum UpdateShopStatus { initial, loading, success, failure }

enum UpdateShopWorkingHourStatus { initial, loading, success, failure }

enum DeleteShopStatus { initial, loading, success, failure }

enum ProductAnalyticStatus { initial, loading, success, failure }

enum ShopVerificationRequestStatus { initial, loading, success, failure }

enum RequestShopVerificationStatus { initial, loading, success, failure }

enum GetShopProductByIdStatus { initial, loading, success, failure }

class ShopState extends Equatable {
  final GetShopProductByIdStatus getShopProductByIdStatus;
  final ShopSearchStatus shopSearchStatus;
  final String searchQuery;
  final List<ShopEntity> searchResult;
  final ShopStatus shopStatus;
  final ShopProductsStatus shopProductsStatus;
  final ShopProductStatus shopProductStatus;
  final ShopProductReviewStatus shopProductReviewStatus;
  final ShopProductImageStatus shopProductImageStatus;
  final ShopProductVideoStatus shopProductVideoStatus;
  final ShopProductWorkStatus shopProductWorkStatus;
  final ShopsListStatus shopsListStatus;
  final Map<String, ProductEntity> archiveProducts;
  final Map<String, ProductEntity> draftProducts;
  final Map<String, ShopEntity> shops;
  final ShopMyProductsStatus shopMyProductsStatus;
  final FilteredProductStatus filteredProductStatus;
  final String? myShopId;
  final DeleteProductStatus deleteProductStatus;
  final AddProductStatus addProductStatus;
  final List<ProductEntity> filteredProducts;
  final MainProductsStatus mainProductStatus;
  final Map<String, ProductEntity> products;
  final Map<String, ProductEntity> favoriteProducts;
  final FavoriteProductsStatus favoriteProductsStatus;
  final UpdateProductStatus updateProductStatus;
  final ListArchiveProductsStatus listArchiveProductsStatus;
  final ListDraftProductsStatus listDraftProductsStatus;
  final ArchiveProductsStatus archiveProductsStatus;
  final DraftProductsStatus draftProductsStatus;
  final UnArchiveProductsStatus unArchiveProductsStatus;
  final UnDraftProductsStatus unDraftProductsStatus;
  final AddReviewStatus addReviewStatus;
  final UpdateReviewStatus updateReviewStatus;
  final DeleteReviewStatus deleteReviewStatus;
  final ShopAnalyticsStatus shopAnalyticsStatus;
  final String errorMessage;
  final AnalyticShopEntity analyticShopEntity;
  final CreateShopStatus createShopStatus;
  final ShopFilterParamter? shopFilterParamter;
  final ProductFilterParamter? productFilterParamter;
  final ShopImageUploadStatus shopImageUploadStatus;
  final UpdateShopStatus updateShopStatus;
  final UpdateShopWorkingHourStatus updateShopWorkingHourStatus;
  final DeleteShopStatus deleteShopStatus;
  final AnalyticProductEntity analyticProductEntity;
  final ProductAnalyticStatus productAnalyticStatus;
  final RequestShopVerificationStatus requestShopVerificationStatus;
  final int homePageTabIndex;
  final ProductEntity? product;

  const ShopState({
    this.getShopProductByIdStatus = GetShopProductByIdStatus.initial,
    this.shopSearchStatus = ShopSearchStatus.initial,
    this.searchQuery = '',
    this.searchResult = const <ShopEntity>[],
    this.shopAnalyticsStatus = ShopAnalyticsStatus.initial,
    this.deleteProductStatus = DeleteProductStatus.initial,
    this.shopStatus = ShopStatus.initial,
    this.shopProductsStatus = ShopProductsStatus.initial,
    this.shopProductStatus = ShopProductStatus.initial,
    this.shopProductReviewStatus = ShopProductReviewStatus.initial,
    this.shopProductImageStatus = ShopProductImageStatus.initial,
    this.shopProductVideoStatus = ShopProductVideoStatus.initial,
    this.shopProductWorkStatus = ShopProductWorkStatus.initial,
    this.shopsListStatus = ShopsListStatus.initial,
    this.shopMyProductsStatus = ShopMyProductsStatus.initial,
    this.addProductStatus = AddProductStatus.initial,
    this.filteredProductStatus = FilteredProductStatus.initial,
    this.shopImageUploadStatus = ShopImageUploadStatus.initial,
    this.archiveProducts = const <String, ProductEntity>{},
    this.draftProducts = const <String, ProductEntity>{},
    this.myShopId,
    this.shops = const <String, ShopEntity>{},
    this.filteredProducts = const <ProductEntity>[],
    this.mainProductStatus = MainProductsStatus.initial,
    this.products = const <String, ProductEntity>{},
    this.favoriteProducts = const <String, ProductEntity>{},
    this.favoriteProductsStatus = FavoriteProductsStatus.initial,
    this.updateProductStatus = UpdateProductStatus.initial,
    this.listArchiveProductsStatus = ListArchiveProductsStatus.initial,
    this.listDraftProductsStatus = ListDraftProductsStatus.initial,
    this.archiveProductsStatus = ArchiveProductsStatus.initial,
    this.draftProductsStatus = DraftProductsStatus.initial,
    this.unArchiveProductsStatus = UnArchiveProductsStatus.initial,
    this.unDraftProductsStatus = UnDraftProductsStatus.initial,
    this.addReviewStatus = AddReviewStatus.initial,
    this.updateReviewStatus = UpdateReviewStatus.initial,
    this.deleteReviewStatus = DeleteReviewStatus.initial,
    this.errorMessage = '',
    this.createShopStatus = CreateShopStatus.initial,
    this.updateShopStatus = UpdateShopStatus.initial,
    this.updateShopWorkingHourStatus = UpdateShopWorkingHourStatus.initial,
    this.deleteShopStatus = DeleteShopStatus.initial,
    this.productAnalyticStatus = ProductAnalyticStatus.initial,
    this.requestShopVerificationStatus = RequestShopVerificationStatus.initial,
    this.shopFilterParamter,
    this.productFilterParamter,
    this.homePageTabIndex = -1,
    this.analyticShopEntity = const AnalyticShopEntity(
      totalFollowers: 0,
      totalReviews: 0,
      totalFavorites: 0,
      totalProducts: 0,
      totalContacts: 0,
      totalViews: 0,
      oneStarReviews: 0,
      twoStarReviews: 0,
      threeStarReviews: 0,
      fourStarReviews: 0,
      fiveStarReviews: 0,
    ),
    this.analyticProductEntity = const AnalyticProductEntity(
      totalViews: 0,
      todayViews: 0,
      totalFavorites: 0,
      totalContacted: 0,
      thisMonthViews: {},
      thisWeekViews: {},
      thisYearViews: {},
    ),
    this.product,
  });

  @override
  List<Object?> get props => [
        getShopProductByIdStatus,
        shopSearchStatus,
        searchQuery,
        searchResult,
        shopStatus,
        shopProductsStatus,
        shopProductStatus,
        shopProductReviewStatus,
        shopProductImageStatus,
        shopProductVideoStatus,
        shopProductWorkStatus,
        shopsListStatus,
        filteredProductStatus,
        archiveProducts,
        draftProducts,
        shops,
        shopMyProductsStatus,
        deleteProductStatus,
        addProductStatus,
        filteredProducts,
        mainProductStatus,
        products,
        favoriteProductsStatus,
        favoriteProducts,
        updateProductStatus,
        listArchiveProductsStatus,
        listDraftProductsStatus,
        archiveProductsStatus,
        draftProductsStatus,
        unArchiveProductsStatus,
        unDraftProductsStatus,
        addReviewStatus,
        updateReviewStatus,
        deleteReviewStatus,
        errorMessage,
        shopAnalyticsStatus,
        analyticShopEntity,
        createShopStatus,
        myShopId,
        shopFilterParamter,
        productFilterParamter,
        shopImageUploadStatus,
        updateShopStatus,
        updateShopWorkingHourStatus,
        deleteShopStatus,
        analyticProductEntity,
        productAnalyticStatus,
        homePageTabIndex,
        requestShopVerificationStatus,
        product,
      ];

  ShopState copyWith({
    GetShopProductByIdStatus? getShopProductByIdStatus,
    ShopSearchStatus? shopSearchStatus,
    String? searchQuery,
    List<ShopEntity>? searchResult,
    ShopStatus? shopStatus,
    ShopProductsStatus? shopProductsStatus,
    ShopProductStatus? shopProductStatus,
    ShopProductReviewStatus? shopProductReviewStatus,
    ShopProductImageStatus? shopProductImageStatus,
    ShopProductVideoStatus? shopProductVideoStatus,
    ShopProductWorkStatus? shopProductWorkStatus,
    ShopsListStatus? shopsListStatus,
    AddProductStatus? addProductStatus,
    Map<String, ProductEntity>? archiveProducts,
    Map<String, ProductEntity>? draftProducts,
    Map<String, ShopEntity>? shops,
    ShopMyProductsStatus? shopMyProductsStatus,
    FilteredProductStatus? filteredProductStatus,
    String? myShopId,
    DeleteProductStatus? deleteProductStatus,
    List<ProductEntity>? filteredProducts,
    MainProductsStatus? mainProductStatus,
    Map<String, ProductEntity>? products,
    Map<String, ProductEntity>? favoriteProducts,
    FavoriteProductsStatus? favoriteProductsStatus,
    UpdateProductStatus? updateProductStatus,
    ListArchiveProductsStatus? listArchiveProductsStatus,
    ListDraftProductsStatus? listDraftProductsStatus,
    ArchiveProductsStatus? archiveProductsStatus,
    DraftProductsStatus? draftProductsStatus,
    UnArchiveProductsStatus? unArchiveProductsStatus,
    UnDraftProductsStatus? unDraftProductsStatus,
    AddReviewStatus? addReviewStatus,
    UpdateReviewStatus? updateReviewStatus,
    DeleteReviewStatus? deleteReviewStatus,
    String? errorMessage,
    int? homePageTabIndex,
    ShopAnalyticsStatus? shopAnalyticsStatus,
    AnalyticShopEntity? analyticShopEntity,
    CreateShopStatus? createShopStatus,
    ShopFilterParamter? shopFilterParamter,
    ProductFilterParamter? productFilterParamter,
    ShopImageUploadStatus? shopImageUploadStatus,
    UpdateShopStatus? updateShopStatus,
    UpdateShopWorkingHourStatus? updateShopWorkingHourStatus,
    DeleteShopStatus? deleteShopStatus,
    AnalyticProductEntity? analyticProductEntity,
    ProductAnalyticStatus? productAnalyticStatus,
    ShopVerificationRequestStatus? shopVerificationRequestStatus,
    RequestShopVerificationStatus? requestShopVerificationStatus,
    ProductEntity? product,
  }) {
    return ShopState(
      getShopProductByIdStatus:
          getShopProductByIdStatus ?? this.getShopProductByIdStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResult: searchResult ?? this.searchResult,
      shopSearchStatus: shopSearchStatus ?? this.shopSearchStatus,
      analyticShopEntity: analyticShopEntity ?? this.analyticShopEntity,
      shopStatus: shopStatus ?? this.shopStatus,
      shopProductsStatus: shopProductsStatus ?? this.shopProductsStatus,
      shopProductStatus: shopProductStatus ?? this.shopProductStatus,
      shopProductReviewStatus:
          shopProductReviewStatus ?? this.shopProductReviewStatus,
      shopProductImageStatus:
          shopProductImageStatus ?? this.shopProductImageStatus,
      shopProductVideoStatus:
          shopProductVideoStatus ?? this.shopProductVideoStatus,
      shopProductWorkStatus:
          shopProductWorkStatus ?? this.shopProductWorkStatus,
      shopsListStatus: shopsListStatus ?? this.shopsListStatus,
      shops: shops ?? this.shops,
      shopMyProductsStatus: shopMyProductsStatus ?? this.shopMyProductsStatus,
      myShopId: myShopId ?? this.myShopId,
      deleteProductStatus: deleteProductStatus ?? this.deleteProductStatus,
      addProductStatus: addProductStatus ?? this.addProductStatus,
      archiveProducts: archiveProducts ?? this.archiveProducts,
      draftProducts: draftProducts ?? this.draftProducts,
      filteredProductStatus:
          filteredProductStatus ?? this.filteredProductStatus,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      mainProductStatus: mainProductStatus ?? this.mainProductStatus,
      products: products ?? this.products,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      favoriteProductsStatus:
          favoriteProductsStatus ?? this.favoriteProductsStatus,
      updateProductStatus: updateProductStatus ?? this.updateProductStatus,
      listArchiveProductsStatus:
          listArchiveProductsStatus ?? this.listArchiveProductsStatus,
      listDraftProductsStatus:
          listDraftProductsStatus ?? this.listDraftProductsStatus,
      archiveProductsStatus:
          archiveProductsStatus ?? this.archiveProductsStatus,
      draftProductsStatus: draftProductsStatus ?? this.draftProductsStatus,
      unArchiveProductsStatus:
          unArchiveProductsStatus ?? this.unArchiveProductsStatus,
      unDraftProductsStatus:
          unDraftProductsStatus ?? this.unDraftProductsStatus,
      addReviewStatus: addReviewStatus ?? this.addReviewStatus,
      updateReviewStatus: updateReviewStatus ?? this.updateReviewStatus,
      deleteReviewStatus: deleteReviewStatus ?? this.deleteReviewStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      shopAnalyticsStatus: shopAnalyticsStatus ?? this.shopAnalyticsStatus,
      createShopStatus: createShopStatus ?? this.createShopStatus,
      shopFilterParamter: shopFilterParamter ?? this.shopFilterParamter,
      productFilterParamter:
          productFilterParamter ?? this.productFilterParamter,
      shopImageUploadStatus:
          shopImageUploadStatus ?? this.shopImageUploadStatus,
      updateShopStatus: updateShopStatus ?? this.updateShopStatus,
      updateShopWorkingHourStatus:
          updateShopWorkingHourStatus ?? this.updateShopWorkingHourStatus,
      deleteShopStatus: deleteShopStatus ?? this.deleteShopStatus,
      analyticProductEntity:
          analyticProductEntity ?? this.analyticProductEntity,
      productAnalyticStatus:
          productAnalyticStatus ?? this.productAnalyticStatus,
      homePageTabIndex: homePageTabIndex ?? this.homePageTabIndex,
      requestShopVerificationStatus:
          requestShopVerificationStatus ?? this.requestShopVerificationStatus,
      product: product ?? this.product,
    );
  }
}

class ShopFilterParamter extends Equatable {
  final Set<String>? selectedCategories;
  final int? selectedVefification;
  final double? selectedRating;
  final double? selectedLatitude;
  final double? selectedLongitude;

  const ShopFilterParamter({
    this.selectedCategories,
    this.selectedVefification,
    this.selectedRating,
    this.selectedLatitude,
    this.selectedLongitude,
  });

  @override
  List<Object?> get props => [
        selectedCategories,
        selectedVefification,
        selectedRating,
        selectedLatitude,
        selectedLongitude,
      ];

  ShopFilterParamter copyWith({
    Set<String>? selectedCategories,
    int? selectedVefification,
    double? selectedRating,
    double? selectedLatitude,
    double? selectedLongitude,
  }) {
    return ShopFilterParamter(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedVefification: selectedVefification ?? this.selectedVefification,
      selectedRating: selectedRating ?? this.selectedRating,
      selectedLatitude: selectedLatitude ?? this.selectedLatitude,
      selectedLongitude: selectedLongitude ?? this.selectedLongitude,
    );
  }

  bool isObjectSame(ShopFilterParamter other) {
    return const DeepCollectionEquality()
            .equals(selectedCategories, other.selectedCategories) &&
        selectedVefification == other.selectedVefification &&
        selectedRating == other.selectedRating &&
        selectedLatitude == other.selectedLatitude &&
        selectedLongitude == other.selectedLongitude;
  }
}

class ProductFilterParamter extends Equatable {
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

  const ProductFilterParamter({
    this.search,
    this.colorIds,
    this.sizeIds,
    this.categoryIds,
    this.brandIds,
    this.materialIds,
    this.designIds,
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

  @override
  List<Object?> get props => [
        search,
        colorIds,
        sizeIds,
        categoryIds,
        brandIds,
        materialIds,
        designIds,
        isNegotiable,
        inStock,
        isNew,
        isDeliverable,
        minPrice,
        maxPrice,
        minQuantity,
        maxQuantity,
        latitudes,
        longitudes,
        radiusInKilometers,
        condition,
        sortBy,
        sortOrder,
      ];

  ProductFilterParamter copyWith({
    String? search,
    List<String>? colorIds,
    List<String>? sizeIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? materialIds,
    List<String>? designIds,
    bool? isNegotiable,
    bool? inStock,
    bool? isNew,
    bool? isDeliverable,
    double? minPrice,
    double? maxPrice,
    int? minQuantity,
    int? maxQuantity,
    double? latitudes,
    double? longitudes,
    double? radiusInKilometers,
    String? condition,
    String? sortBy,
    String? sortOrder,
  }) {
    return ProductFilterParamter(
      search: search ?? this.search,
      colorIds: colorIds ?? this.colorIds,
      sizeIds: sizeIds ?? this.sizeIds,
      categoryIds: categoryIds ?? this.categoryIds,
      brandIds: brandIds ?? this.brandIds,
      materialIds: materialIds ?? this.materialIds,
      designIds: designIds ?? this.designIds,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      inStock: inStock ?? this.inStock,
      isNew: isNew ?? this.isNew,
      isDeliverable: isDeliverable ?? this.isDeliverable,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      latitudes: latitudes ?? this.latitudes,
      longitudes: longitudes ?? this.longitudes,
      radiusInKilometers: radiusInKilometers ?? this.radiusInKilometers,
      condition: condition ?? this.condition,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  bool isObjectSame(ProductFilterParamter other) {
    return const DeepCollectionEquality().equals(search, other.search) &&
        const DeepCollectionEquality().equals(colorIds, other.colorIds) &&
        const DeepCollectionEquality().equals(sizeIds, other.sizeIds) &&
        const DeepCollectionEquality().equals(categoryIds, other.categoryIds) &&
        const DeepCollectionEquality().equals(brandIds, other.brandIds) &&
        const DeepCollectionEquality().equals(materialIds, other.materialIds) &&
        const DeepCollectionEquality().equals(designIds, other.designIds) &&
        isNegotiable == other.isNegotiable &&
        inStock == other.inStock &&
        isNew == other.isNew &&
        isDeliverable == other.isDeliverable &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        minQuantity == other.minQuantity &&
        maxQuantity == other.maxQuantity &&
        latitudes == other.latitudes &&
        longitudes == other.longitudes &&
        radiusInKilometers == other.radiusInKilometers &&
        condition == other.condition &&
        sortBy == other.sortBy &&
        sortOrder == other.sortOrder;
  }
}
