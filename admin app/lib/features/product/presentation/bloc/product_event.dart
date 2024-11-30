part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductsEvent extends ProductEvent {
  final String token;

  const GetProductsEvent({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class ProductApprovalEvent extends ProductEvent {
  final String token;
  final String id;
  final int status;

  const ProductApprovalEvent(
      {required this.token, required this.id, required this.status});
}

class AddNewProductEvent extends ProductEvent {
  final String product;

  const AddNewProductEvent({
    required this.product,
  });
}

class SignalRStartEvent extends ProductEvent {}