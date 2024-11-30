part of 'auth_bloc.dart';



 class AuthState extends Equatable {

  final ApiRequestStatus signInStatus;
  final UserEntity? user;
  final String? error;
  final ApiRequestStatus loadCurrentUserStatus;
  final ApiRequestStatus signOutStatus;
  final ApiRequestStatus updateAccessTokenStatus;
  const AuthState(
      {this.signInStatus = ApiRequestStatus.initial,
      this.loadCurrentUserStatus = ApiRequestStatus.initial,
      this.signOutStatus = ApiRequestStatus.initial,
      this.updateAccessTokenStatus = ApiRequestStatus.initial,
      this.user,
      this.error});
  

  AuthState copyWith({
    ApiRequestStatus? signInStatus,
    ApiRequestStatus? loadCurrentUserStatus,
    ApiRequestStatus? signOutStatus,
    ApiRequestStatus? updateAccessTokenStatus,
    UserEntity? user,
    String? error,
  }) {
    return AuthState(
      signInStatus: signInStatus ?? this.signInStatus,
      loadCurrentUserStatus: loadCurrentUserStatus ?? this.loadCurrentUserStatus,
      signOutStatus: signOutStatus ?? this.signOutStatus,
      updateAccessTokenStatus: updateAccessTokenStatus ?? this.updateAccessTokenStatus,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [signInStatus, user, error, loadCurrentUserStatus, signOutStatus, updateAccessTokenStatus];
}

