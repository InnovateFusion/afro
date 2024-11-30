part of 'general_bloc.dart';

@immutable
sealed class GeneralEvent extends Equatable {
  const GeneralEvent();

  @override
  List<Object> get props => [];
}

class VerifyEmailRequestEvent extends GeneralEvent {
  final String email;
  final String token;

  const VerifyEmailRequestEvent({required this.email, required this.token});
}

class VerifyEmailCodeEvent extends GeneralEvent {
  final String email;
  final String code;
  final String token;

  const VerifyEmailCodeEvent({required this.email, required this.code, required this.token});
}

class ResetGeneralStateEvent extends GeneralEvent {}

class OnVerifyEmailSuccessEvent extends GeneralEvent {}