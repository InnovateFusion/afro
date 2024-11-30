import '../../../../core/utils/enum.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/product_approval.dart';
import '../../../../setUp/service/signalr_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/add_new_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase getProductUseCase;
  final ProductApprovalUseCase productApprovalUseCase;
  final SignalRService signalRService;
  final AddNewProductUseCase addNewProductUseCase;

  ProductBloc({
    required this.signalRService,
    required this.getProductUseCase,
    required this.productApprovalUseCase,
    required this.addNewProductUseCase,
  }) : super(const ProductState()) {
    signalRService.hubConnection?.keepAliveIntervalInMilliseconds = 600000;
    signalRService.hubConnection?.on('ReceiveMessage', (message) {
      if (message != null && message.isNotEmpty) {
        if (message.length == 2) {
          if (message[0].toString() == "notification-for-admin-product") {
            add(AddNewProductEvent(product: message[1].toString()));
          }
        }
      }
    });

    on<SignalRStartEvent>((event, emit) async {
      emit(state.copyWith(realTimeMessageStatus: ApiRequestStatus.connecting));
      if (signalRService.isConnected) {
        await signalRService.startConnection();
      }
      emit(state.copyWith(realTimeMessageStatus: ApiRequestStatus.connected));
    });

    on<AddNewProductEvent>((event, emit) async {
      emit(state.copyWith(addNewProduct: ApiRequestStatus.loading));
      final result = await addNewProductUseCase(AddNewProductParams(
        product: event.product,
      ));
      result.fold(
        (failure) {
          emit(state.copyWith(addNewProduct: ApiRequestStatus.error));
        },
        (product) {
          emit(state.copyWith(
              products: [product, ...state.products],
              addNewProduct: ApiRequestStatus.error));
        },
      );
    });

    on<GetProductsEvent>((event, emit) async {
      if (state.products.isEmpty) {
        emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loading));
      } else {
        emit(state.copyWith(apiRequestStatus: ApiRequestStatus.loadMore));
      }
      final result = await getProductUseCase(GetProductParams(
          token: event.token, limit: 8, skip: state.products.length));
      result.fold(
        (failure) {
          emit(state.copyWith(apiRequestStatus: ApiRequestStatus.error));
        },
        (products) {
          emit(state.copyWith(
              apiRequestStatus: ApiRequestStatus.success,
              products: [...state.products, ...products]));
        },
      );
    });

    on<ProductApprovalEvent>((event, emit) async {
      final products = state.products;

      emit(state.copyWith(
        productApprovalStatus: ApiRequestStatus.loading,
        products:
            state.products.where((product) => product.id != event.id).toList(),
      ));
      final result = await productApprovalUseCase(ProductApprovalParams(
          token: event.token, id: event.id, status: event.status));
      result.fold(
        (failure) {
          emit(state.copyWith(
              productApprovalStatus: ApiRequestStatus.error,
              products: products));
        },
        (products) {
          emit(state.copyWith(
            productApprovalStatus: ApiRequestStatus.success,
          ));
        },
      );
    });
  }
}
