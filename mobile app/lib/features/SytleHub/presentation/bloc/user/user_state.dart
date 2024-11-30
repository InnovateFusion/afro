part of 'user_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

enum SignUpStatus { initial, loading, success, failure }

enum SendVerificationEmailRequestStatus { initial, loading, success, failure }

enum VerifyEmailStatus { initial, loading, success, failure }

enum ResetPasswordRequestStatus { initial, loading, success, failure }

enum ResetPasswordStatus { initial, loading, success, failure }

enum VerifyPasswordCodeStatus { initial, loading, success, failure }

enum LoadCurrentUserStatus { initial, loading, success, failure }

enum MyProfileStatus { initial, loading, success, failure }

enum UpdateAccessTokenStatus { initial, loading, success, failure }

enum LoginWithTiktokStatus { initial, loading, success, failure }

enum GetTiktokerProfileDetailStatus { initial, loading, success, failure }

enum ConnectToTiktokStatus { initial, loading, success, failure }

enum DisConnectFromTiktokStatus { initial, loading, success, failure }

class UserState extends Equatable {
  final LoginStatus loginStatus;
  final SignUpStatus signUpStatus;
  final SendVerificationEmailRequestStatus sendVerificationEmailRequestStatus;
  final VerifyEmailStatus verifyEmailStatus;
  final VerifyPasswordCodeStatus verifyPasswordCodeStatus;
  final ResetPasswordRequestStatus resetPasswordRequestStatus;
  final ResetPasswordStatus resetPasswordStatus;
  final LoadCurrentUserStatus loadCurrentUserStatus;
  final MyProfileStatus myProfileStatus;
  final UpdateAccessTokenStatus updateAccessTokenStatus;
  final LoginWithTiktokStatus loginWithTiktokStatus;
  final GetTiktokerProfileDetailStatus getTiktokerProfileDetailStatus;
  final DisConnectFromTiktokStatus disConnectFromTiktokStatus;
  final ConnectToTiktokStatus connectToTiktokStatus;
  final TiktokUserEntity? tiktoker;
  final UserEntity? user;
  final String? errorMessage;
  final String? email;
  final String? code;

  const UserState({
    this.loginStatus = LoginStatus.initial,
    this.signUpStatus = SignUpStatus.initial,
    this.loadCurrentUserStatus = LoadCurrentUserStatus.initial,
    this.sendVerificationEmailRequestStatus =
        SendVerificationEmailRequestStatus.initial,
    this.verifyEmailStatus = VerifyEmailStatus.initial,
    this.verifyPasswordCodeStatus = VerifyPasswordCodeStatus.initial,
    this.resetPasswordRequestStatus = ResetPasswordRequestStatus.initial,
    this.resetPasswordStatus = ResetPasswordStatus.initial,
    this.myProfileStatus = MyProfileStatus.initial,
    this.updateAccessTokenStatus = UpdateAccessTokenStatus.initial,
    this.loginWithTiktokStatus = LoginWithTiktokStatus.initial,
    this.getTiktokerProfileDetailStatus = GetTiktokerProfileDetailStatus.initial,
    this.disConnectFromTiktokStatus = DisConnectFromTiktokStatus.initial,
    this.connectToTiktokStatus = ConnectToTiktokStatus.initial,
    this.tiktoker,
    this.user,
    this.errorMessage,
    this.email,
    this.code,
  });

  @override
  List<Object?> get props => [
        loginStatus,
        signUpStatus,
        sendVerificationEmailRequestStatus,
        verifyEmailStatus,
        resetPasswordRequestStatus,
        resetPasswordStatus,
        myProfileStatus,
        getTiktokerProfileDetailStatus,
        disConnectFromTiktokStatus,
        connectToTiktokStatus,
        tiktoker,
        user,
        verifyPasswordCodeStatus,
        updateAccessTokenStatus,
        loginWithTiktokStatus,
        errorMessage,
        loadCurrentUserStatus,
        email,
        code,
      ];

  UserState copyWith({
    LoginStatus? loginStatus,
    SignUpStatus? signUpStatus,
    SendVerificationEmailRequestStatus? sendVerificationEmailRequestStatus,
    VerifyEmailStatus? verifyEmailStatus,
    ResetPasswordRequestStatus? resetPasswordRequestStatus,
    ResetPasswordStatus? resetPasswordStatus,
    VerifyPasswordCodeStatus? verifyPasswordCodeStatus,
    MyProfileStatus? myProfileStatus,
    UpdateAccessTokenStatus? updateAccessTokenStatus,
    LoginWithTiktokStatus? loginWithTiktokStatus,
    GetTiktokerProfileDetailStatus? getTiktokerProfileDetailStatus,
    DisConnectFromTiktokStatus? disConnectFromTiktokStatus,
    ConnectToTiktokStatus? connectToTiktokStatus,
    TiktokUserEntity? tiktoker,
    UserEntity? user,
    LoadCurrentUserStatus? loadCurrentUserStatus,
    String? email,
    String? code,
    String? errorMessage,
    List<NotificationEntity>? notifications,
    
  }) {
    return UserState(
      loginStatus: loginStatus ?? this.loginStatus,
      signUpStatus: signUpStatus ?? this.signUpStatus,
      sendVerificationEmailRequestStatus: sendVerificationEmailRequestStatus ??
          this.sendVerificationEmailRequestStatus,
      verifyEmailStatus: verifyEmailStatus ?? this.verifyEmailStatus,
      resetPasswordRequestStatus:
          resetPasswordRequestStatus ?? this.resetPasswordRequestStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      myProfileStatus: myProfileStatus ?? this.myProfileStatus,
      updateAccessTokenStatus:
          updateAccessTokenStatus ?? this.updateAccessTokenStatus,
      loginWithTiktokStatus: loginWithTiktokStatus ?? this.loginWithTiktokStatus,
      getTiktokerProfileDetailStatus: getTiktokerProfileDetailStatus ?? this.getTiktokerProfileDetailStatus,
      disConnectFromTiktokStatus: disConnectFromTiktokStatus ?? this.disConnectFromTiktokStatus,
      connectToTiktokStatus: connectToTiktokStatus ?? this.connectToTiktokStatus,
      tiktoker: tiktoker ?? this.tiktoker,
      user: user ?? this.user,
      verifyPasswordCodeStatus:
          verifyPasswordCodeStatus ?? this.verifyPasswordCodeStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      code: code ?? this.code,
      loadCurrentUserStatus:
          loadCurrentUserStatus ?? this.loadCurrentUserStatus,
    );
  }
}
