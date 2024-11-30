part of 'product_bloc.dart';

enum ColorStatus { initial, loading, success, failure }

enum SizeStatus { initial, loading, success, failure }

enum CategoryStatus { initial, loading, success, failure }

enum BrandStatus { initial, loading, success, failure }

enum MaterialStatus { initial, loading, success, failure }

enum LocationStatus { initial, loading, success, failure }

enum DesignStatus { initial, loading, success, failure }

enum DomainStatus { initial, loading, success, failure }

enum MyPasswordResetStatus { initial, loading, success, failure }

enum ProductSearchStatus { initial, loading, success, failure, noMore, loadMore }

enum GetProductByIdStatus { initial, loading, success, failure }

enum ShareProductToTiktokStatus { initial, loading, success, failure }

enum BackgroundRemoveStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductSearchStatus searchStatus;
  final String searchQuery;
  final List<ProductEntity> searchResult;
  final List<ColorEntity> colors;
  final ColorStatus colorStatus;
  final List<SizeEntity> sizes;
  final SizeStatus sizeStatus;
  final List<CategoryEntity> categories;
  final CategoryStatus categoryStatus;
  final List<BrandEntity> brands;
  final BrandStatus brandStatus;
  final List<MaterialEntity> materials;
  final MaterialStatus materialStatus;
  final List<LocationEntity> locations;
  final LocationStatus locationStatus;
  final List<DesignEntity> designs;
  final DesignStatus designStatus;
  final List<DomainEntity> domains;
  final DomainStatus domainStatus;
  final MyPasswordResetStatus myPasswordResetStatus;
  final String errorMessage;
  final GetProductByIdStatus getProductByIdStatus;
  final ProductEntity? product;
  final ShareProductToTiktokStatus shareProductToTiktokStatus;
  final File? image;
  final BackgroundRemoveStatus backgroundRemoveStatus;

  const ProductState({
    this.searchStatus = ProductSearchStatus.initial,
    this.searchQuery = '',
    this.searchResult = const <ProductEntity>[],
    this.colors = const <ColorEntity>[],
    this.colorStatus = ColorStatus.initial,
    this.sizes = const <SizeEntity>[],
    this.sizeStatus = SizeStatus.initial,
    this.categories = const <CategoryEntity>[],
    this.categoryStatus = CategoryStatus.initial,
    this.brands = const <BrandEntity>[],
    this.brandStatus = BrandStatus.initial,
    this.materials = const <MaterialEntity>[],
    this.materialStatus = MaterialStatus.initial,
    this.locations = const <LocationEntity>[],
    this.locationStatus = LocationStatus.initial,
    this.designs = const <DesignEntity>[],
    this.designStatus = DesignStatus.initial,
    this.domains = const <DomainEntity>[],
    this.domainStatus = DomainStatus.initial,
    this.myPasswordResetStatus = MyPasswordResetStatus.initial,
    this.errorMessage = '',
    this.getProductByIdStatus = GetProductByIdStatus.initial,
    this.shareProductToTiktokStatus = ShareProductToTiktokStatus.initial,
    this.product,
    this.image,
    this.backgroundRemoveStatus = BackgroundRemoveStatus.initial,
  });

  ProductState copyWith({
    ProductSearchStatus? searchStatus,
    String? searchQuery,
    List<ProductEntity>? searchResult,
    List<ColorEntity>? colors,
    ColorStatus? colorStatus,
    List<SizeEntity>? sizes,
    SizeStatus? sizeStatus,
    List<CategoryEntity>? categories,
    CategoryStatus? categoryStatus,
    List<BrandEntity>? brands,
    BrandStatus? brandStatus,
    List<MaterialEntity>? materials,
    MaterialStatus? materialStatus,
    List<LocationEntity>? locations,
    LocationStatus? locationStatus,
    List<DesignEntity>? designs,
    DesignStatus? designStatus,
    List<DomainEntity>? domains,
    DomainStatus? domainStatus,
    MyPasswordResetStatus? myPasswordResetStatus,
    String? errorMessage,
    GetProductByIdStatus? getProductByIdStatus,
    ShareProductToTiktokStatus? shareProductToTiktokStatus,
    ProductEntity? product,
    File? image,
    BackgroundRemoveStatus? backgroundRemoveStatus,
  }) {
    return ProductState(
      searchStatus: searchStatus ?? this.searchStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResult: searchResult ?? this.searchResult,
      colors: colors ?? this.colors,
      colorStatus: colorStatus ?? this.colorStatus,
      sizes: sizes ?? this.sizes,
      sizeStatus: sizeStatus ?? this.sizeStatus,
      categories: categories ?? this.categories,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      brands: brands ?? this.brands,
      brandStatus: brandStatus ?? this.brandStatus,
      materials: materials ?? this.materials,
      materialStatus: materialStatus ?? this.materialStatus,
      locations: locations ?? this.locations,
      locationStatus: locationStatus ?? this.locationStatus,
      designs: designs ?? this.designs,
      designStatus: designStatus ?? this.designStatus,
      domains: domains ?? this.domains,
      domainStatus: domainStatus ?? this.domainStatus,
      myPasswordResetStatus: myPasswordResetStatus ?? this.myPasswordResetStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      getProductByIdStatus: getProductByIdStatus ?? this.getProductByIdStatus,
      shareProductToTiktokStatus: shareProductToTiktokStatus ?? this.shareProductToTiktokStatus,
      product: product ?? this.product,
      image: image ?? this.image,
      backgroundRemoveStatus: backgroundRemoveStatus ?? this.backgroundRemoveStatus,
    );
  }

  @override
  List<Object?> get props => [
        searchStatus,
        searchQuery,
        searchResult,
        colors,
        colorStatus,
        sizes,
        sizeStatus,
        categories,
        categoryStatus,
        brands,
        brandStatus,
        materials,
        materialStatus,
        locations,
        locationStatus,
        designs,
        designStatus,
        domains,
        domainStatus,
        myPasswordResetStatus,
        errorMessage,
        shareProductToTiktokStatus,
        getProductByIdStatus,
        product,
        image,
        backgroundRemoveStatus,
      ];
}
