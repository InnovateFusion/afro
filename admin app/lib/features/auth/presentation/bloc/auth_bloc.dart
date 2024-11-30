import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/use_cases/usecase.dart';
import '../../../../core/utils/enum.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/load_currect_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/update_access_token.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final LoadCurrectUserUseCase loadCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;
  final UpdateAccessTokenUseCase updateAccessTokenUseCase;
  AuthBloc({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.loadCurrentUserUseCase,
    required this.updateAccessTokenUseCase,
  }) : super(const AuthState()) {
    on<SignInEvent>(_onSignIn);
    on<LoadCurrentUserEvent>(_onLoadCurrentUser);
    on<SignOutEvent>((event, emit) {
      emit(state.copyWith(signOutStatus: ApiRequestStatus.loading));
      signOutUseCase(NoParams()).then((result) {
        result.fold(
          (failure) => emit(state.copyWith(
              signOutStatus: ApiRequestStatus.error, error: failure.message)),
          (success) => emit(const AuthState()),
        );
      });
      emit(state.copyWith(signOutStatus: ApiRequestStatus.success, user: null));
    });
    on<UpdateAccessTokenEvent>((event, emit) async {
      emit(state.copyWith(updateAccessTokenStatus: ApiRequestStatus.loading));
      final result = await updateAccessTokenUseCase(UpdateAccessTokenParams(
          refeshToken: state.user?.refreshToken ?? 'x'));

      result.fold(
        (failure) => emit(state.copyWith(
            updateAccessTokenStatus: ApiRequestStatus.error,
            error: failure.message)),
        (success) => emit(state.copyWith(
            updateAccessTokenStatus: ApiRequestStatus.success, user: success)),
      );
    });
  }

  void _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(signInStatus: ApiRequestStatus.loading));
    final result = await signInUseCase(SignInParams(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          signInStatus: ApiRequestStatus.error, error: failure.message)),
      (success) => emit(state.copyWith(
          signInStatus: ApiRequestStatus.success, user: success, error: null)),
    );
  }

  void _onLoadCurrentUser(LoadCurrentUserEvent event, Emitter<AuthState> emit) {
    loadCurrentUserUseCase(NoParams()).then((result) {
      result.fold(
        (failure) => emit(state.copyWith(
            error: failure.message,
            loadCurrentUserStatus: ApiRequestStatus.error)),
        (user) => emit(state.copyWith(
            loadCurrentUserStatus: ApiRequestStatus.success, user: user)),
      );
    });
  }
}
