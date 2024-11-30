part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final ApiRequestStatus apiRequestStatus;
  final ApiRequestStatus productApprovalStatus;
  final ApiRequestStatus addNewProduct;
  final ApiRequestStatus realTimeMessageStatus;
  const ProductState({
    this.apiRequestStatus = ApiRequestStatus.initial,
    this.productApprovalStatus = ApiRequestStatus.initial,
    this.addNewProduct = ApiRequestStatus.initial,
    this.realTimeMessageStatus = ApiRequestStatus.initial,
    this.products = const [],
  });

  @override
  List<Object?> get props =>
      [products, apiRequestStatus, productApprovalStatus, addNewProduct, realTimeMessageStatus];

  ProductState copyWith({
    List<ProductEntity>? products,
    ApiRequestStatus? apiRequestStatus,
    ApiRequestStatus? productApprovalStatus,
    ApiRequestStatus? addNewProduct,
    ApiRequestStatus? realTimeMessageStatus,

  }) {
    return ProductState(
      products: products ?? this.products,
      apiRequestStatus: apiRequestStatus ?? this.apiRequestStatus,
      productApprovalStatus: productApprovalStatus ?? this.apiRequestStatus,
      addNewProduct: addNewProduct ?? this.addNewProduct,
      realTimeMessageStatus: realTimeMessageStatus ?? this.realTimeMessageStatus,
    );
  }
}
