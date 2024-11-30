import '../../../../core/utils/enum.dart';
import '../../domain/usecases/get_products.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/shop_entity.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetShopUseCase getShopUseCase;

  ShopBloc({
    required this.getShopUseCase,
  }) : super(const ShopState()) {
    on<FetchShopsEvent>((event, emit) async {
      if (state.shops.isEmpty) {
        emit(state.copyWith(shopRequestStatus: ApiRequestStatus.loading));
      } else {
        emit(state.copyWith(shopRequestStatus: ApiRequestStatus.loadMore));
      }

      final result = await getShopUseCase(
        GetShopParams(
          token: event.token,
          limit: 10,
          skip: state.shops.length,
        ),
      );
      result.fold(
        (failure) {
          emit(state.copyWith(shopRequestStatus: ApiRequestStatus.error));
        },
        (shops) {
          emit(state.copyWith(
            shops: [...state.shops, ...shops],
            shopRequestStatus: ApiRequestStatus.success,
          ));
        },
      );
    });
  }
}
