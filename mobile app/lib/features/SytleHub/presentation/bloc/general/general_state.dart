part of 'general_bloc.dart';

enum RequestVerificationEmailStatus { initial, loading, success, failure, done }

enum EmailVerifyCodeStatus { initial, loading, success, failure, done }

class GeneralState extends Equatable {
  final RequestVerificationEmailStatus sendVerificationEmailRequestStatus;
  final EmailVerifyCodeStatus verifyEmailStatus;
  final String? errorMessage;

  const GeneralState(
      {this.sendVerificationEmailRequestStatus =
          RequestVerificationEmailStatus.initial,
      this.verifyEmailStatus = EmailVerifyCodeStatus.initial,
      this.errorMessage = ""});

  @override
  List<Object?> get props =>
      [sendVerificationEmailRequestStatus, verifyEmailStatus, errorMessage];

  GeneralState copyWith(
      {RequestVerificationEmailStatus? sendVerificationEmailRequestStatus,
      EmailVerifyCodeStatus? verifyEmailStatus,
      String? errorMessage}) {
    return GeneralState(
        sendVerificationEmailRequestStatus:
            sendVerificationEmailRequestStatus ??
                this.sendVerificationEmailRequestStatus,
        verifyEmailStatus: verifyEmailStatus ?? this.verifyEmailStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
