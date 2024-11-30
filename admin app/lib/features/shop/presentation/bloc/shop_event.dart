part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class FetchShopsEvent extends ShopEvent {
  final String token;
  const FetchShopsEvent(
    {required this.token}
  );
}
