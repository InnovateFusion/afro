import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:style_hub/features/SytleHub/domain/usecases/user/send_verification_code.dart'
    as send_verification_code;
import 'package:style_hub/features/SytleHub/domain/usecases/user/verify_code.dart'
    as verify_code;

import '../../../domain/usecases/user/send_profile_verification_code.dart'
    as send_profile_verification_code;
import '../../../domain/usecases/user/verify_profile_code.dart' as verify_profile_code;

part 'general_event.dart';
part 'general_state.dart';

class GeneralBloc extends Bloc<GeneralEvent, GeneralState> {
  final send_verification_code.SendVerificationCodeUseCase
      sendVerificationCodeUseCase;
  final verify_code.VerifyCodeUseCase verifyCodeUseCase;
  final send_profile_verification_code.SendProfileVerificationCodeUseCase
      sendProfileVerificationCodeUseCase;
  final verify_profile_code.VerifyProfileCodeUseCase verifyProfileCodeUseCase;

  GeneralBloc(
      {required this.sendVerificationCodeUseCase,
      required this.sendProfileVerificationCodeUseCase,
      required this.verifyCodeUseCase,
      required this.verifyProfileCodeUseCase
      
      })
      : super(const GeneralState()) {
    on<VerifyEmailRequestEvent>(_onSendVerificationCode);
    on<VerifyEmailCodeEvent>(_onVerifyCode);
    on<ResetGeneralStateEvent>(_onResetState);
    on<OnVerifyEmailSuccessEvent>(_onVerifyEmailSuccess);
  }

  void _onSendVerificationCode(
      VerifyEmailRequestEvent event, Emitter<GeneralState> emit) async {
    emit(state.copyWith(
      sendVerificationEmailRequestStatus:
          RequestVerificationEmailStatus.loading,
    ));
    final result = await sendProfileVerificationCodeUseCase(
        send_profile_verification_code.Params(
      email: event.email,
      token: event.token,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          sendVerificationEmailRequestStatus:
              RequestVerificationEmailStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          sendVerificationEmailRequestStatus:
              RequestVerificationEmailStatus.success)),
    );
  }

  void _onVerifyCode(
      VerifyEmailCodeEvent event, Emitter<GeneralState> emit) async {
    emit(state.copyWith(
      verifyEmailStatus: EmailVerifyCodeStatus.loading,
      sendVerificationEmailRequestStatus: RequestVerificationEmailStatus.done,
    ));
    final result = await verifyProfileCodeUseCase(verify_profile_code.Params(
      email: event.email,
      code: event.code,
      token: event.token,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          verifyEmailStatus: EmailVerifyCodeStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(
          state.copyWith(verifyEmailStatus: EmailVerifyCodeStatus.success)),
    );
  }

  void _onResetState(ResetGeneralStateEvent event, Emitter<GeneralState> emit) {
    emit(const GeneralState());
  }

  void _onVerifyEmailSuccess(
      OnVerifyEmailSuccessEvent event, Emitter<GeneralState> emit) {
    emit(state.copyWith(
      verifyEmailStatus: EmailVerifyCodeStatus.done,
    ));
  }
}
