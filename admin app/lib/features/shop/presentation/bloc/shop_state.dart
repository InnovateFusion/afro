part of 'shop_bloc.dart';

 class ShopState extends Equatable {
  final List<ShopEntity> shops;
  final ApiRequestStatus shopRequestStatus;
  const ShopState({
    this.shops = const [],
    this.shopRequestStatus = ApiRequestStatus.initial,
  });  

  @override
  List<Object> get props => [ shops, shopRequestStatus ];

  ShopState copyWith({
    List<ShopEntity>? shops,
    ApiRequestStatus? shopRequestStatus,
  }) {
    return ShopState(
      shops: shops ?? this.shops,
      shopRequestStatus: shopRequestStatus ?? this.shopRequestStatus,
    );
  }
}

