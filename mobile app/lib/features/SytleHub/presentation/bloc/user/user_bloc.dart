import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:style_hub/features/SytleHub/domain/usecases/user/connect_from_tiktok.dart'
    as connect_from_tiktok;
import 'package:style_hub/features/SytleHub/domain/usecases/user/get_tiktoker_profile_detail.dart'
    as get_tiktoker_profile_detail;
import 'package:style_hub/features/SytleHub/domain/usecases/user/load_currect_user.dart'
    as load_current_user;
import 'package:style_hub/features/SytleHub/domain/usecases/user/login_with_tiktok.dart'
    as login_with_tiktok;
import 'package:style_hub/features/SytleHub/domain/usecases/user/my_profile.dart'
    as my_profile;
import 'package:style_hub/features/SytleHub/domain/usecases/user/password_reset_verify_code.dart'
    as verify_password_code;
import 'package:style_hub/features/SytleHub/domain/usecases/user/referesh_tiktok_access_token.dart'
    as referesh_tiktok_access_token;
import 'package:style_hub/features/SytleHub/domain/usecases/user/reset_password.dart'
    as reset_password;
import 'package:style_hub/features/SytleHub/domain/usecases/user/reset_password_request.dart'
    as reset_password_request;
import 'package:style_hub/features/SytleHub/domain/usecases/user/send_verification_code.dart'
    as send_verification_code;
import 'package:style_hub/features/SytleHub/domain/usecases/user/sign_in.dart'
    as sign_in_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/user/sign_out.dart'
    as sign_out;
import 'package:style_hub/features/SytleHub/domain/usecases/user/sign_up.dart'
    as sign_up_usecase;
import 'package:style_hub/features/SytleHub/domain/usecases/user/update_access_token.dart'
    as update_access_token;
import 'package:style_hub/features/SytleHub/domain/usecases/user/verify_code.dart'
    as verify_code;

import '../../../../../core/use_cases/usecase.dart';
import '../../../domain/entities/user/notification_entity.dart';
import '../../../domain/entities/user/notification_setting_entity.dart';
import '../../../domain/entities/user/tiktok_user_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/user/dis_connect_from_tiktok.dart'
    as dis_connect_from_tiktok;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final sign_in_usecase.SignInUseCase signInUseCase;
  final sign_up_usecase.SignUpUseCase signUpUseCase;
  final send_verification_code.SendVerificationCodeUseCase
      sendVerificationCodeUseCase;
  final verify_code.VerifyCodeUseCase verifyCodeUseCase;
  final reset_password_request.ResetPasswordRequestUseCase
      resetPasswordRequestUseCase;
  final reset_password.ResetPasswordUseCase resetPasswordUseCase;
  final verify_password_code.PasswordResetVerifyCodeUseCase
      verifyPasswordCodeUseCase;
  final sign_out.SignOutUseCase signOutUseCase;
  final load_current_user.LoadCurrectUserUseCase loadCurrentUserUseCase;
  final my_profile.MyProfileUsecase myProfileUseCase;
  final update_access_token.UpdateAccessToken updateAccessToken;
  final login_with_tiktok.LoginWithTiktokUsecase loginWithTiktokUsecase;
  final referesh_tiktok_access_token.RefereshTiktokAccessTokenUseCase
      refereshTiktokAccessTokenUseCase;
  final get_tiktoker_profile_detail.GetTiktokerProfileDetailUseCase
      getTiktokerProfileDetailUseCase;
  final dis_connect_from_tiktok.DisConnectFromTiktokUseCase
      disConnectFromTiktokUseCase;
  final connect_from_tiktok.ConnectFromTiktokUseCase connectFromTiktokUseCase;

  UserBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.sendVerificationCodeUseCase,
    required this.verifyCodeUseCase,
    required this.resetPasswordRequestUseCase,
    required this.resetPasswordUseCase,
    required this.verifyPasswordCodeUseCase,
    required this.signOutUseCase,
    required this.loadCurrentUserUseCase,
    required this.myProfileUseCase,
    required this.updateAccessToken,
    required this.loginWithTiktokUsecase,
    required this.refereshTiktokAccessTokenUseCase,
    required this.getTiktokerProfileDetailUseCase,
    required this.disConnectFromTiktokUseCase,
    required this.connectFromTiktokUseCase,
  }) : super(const UserState()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SendVerificationEmailRequestEvent>(_onSendVerificationCode);
    on<VerifyEmailEvent>(_onVerifyCode);
    on<ResetPasswordRequestEvent>(_onResetPasswordRequest);
    on<ResetPasswordEvent>(_onResetPassword);
    on<VerifyPasswordCodeEvent>(_onVerifyPasswordCode);
    on<ClearStateEvent>(_onClearState);
    on<SignOutEvent>(_onSignOut);
    on<LoadCurrentUserEvent>(_onLoadCurrentUser);
    on<UpdateProfileEvent>(_onMyProfile);
    on<UpdateAccessTokenEvent>(_onUpdateAccessToken);
    on<LoginWithTiktokEvent>(_onLoginWithTiktok);
    on<RefereshTiktokAccessTokenEvent>(_onRefereshTiktokAccessToken);
    on<DisConnectFromTiktokEvent>(_onDisConnectFromTiktok);
    on<GetTiktokerInfoEvent>(_onGetTiktokerProfileDetail);
    on<ConnectToTiktokEvent>(_onConnectToTiktok);
    on<EmailVerifiedEvent>(_onEmailVerified);
    on<RefereshAllEvent>(_onRefereshAll);
  }

  void _onSignIn(SignInEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading, email: event.email));
    final result = await signInUseCase(sign_in_usecase.Params(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          loginStatus: LoginStatus.failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          loginStatus: LoginStatus.success, user: success, errorMessage: null)),
    );
  }

  void _onSignUp(SignUpEvent event, Emitter<UserState> emit) async {
    emit(
        state.copyWith(signUpStatus: SignUpStatus.loading, email: event.email));
    final result = await signUpUseCase(sign_up_usecase.Params(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          signUpStatus: SignUpStatus.failure, errorMessage: failure.message)),
      (success) => emit(state.copyWith(signUpStatus: SignUpStatus.success)),
    );
  }

  void _onSendVerificationCode(
      SendVerificationEmailRequestEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
        sendVerificationEmailRequestStatus:
            SendVerificationEmailRequestStatus.loading,
        email: event.email));
    final result =
        await sendVerificationCodeUseCase(send_verification_code.Params(
      email: event.email,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          sendVerificationEmailRequestStatus:
              SendVerificationEmailRequestStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          sendVerificationEmailRequestStatus:
              SendVerificationEmailRequestStatus.success)),
    );
  }

  void _onVerifyCode(VerifyEmailEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
        verifyEmailStatus: VerifyEmailStatus.loading,
        email: event.email,
        code: event.code));
    final result = await verifyCodeUseCase(verify_code.Params(
      email: event.email,
      code: event.code,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          verifyEmailStatus: VerifyEmailStatus.failure,
          errorMessage: failure.message)),
      (success) =>
          emit(state.copyWith(verifyEmailStatus: VerifyEmailStatus.success)),
    );
  }

  void _onVerifyPasswordCode(
      VerifyPasswordCodeEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
        verifyPasswordCodeStatus: VerifyPasswordCodeStatus.loading,
        email: event.email,
        code: event.code));
    final result = await verifyPasswordCodeUseCase(verify_password_code.Params(
      email: event.email,
      code: event.code,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          verifyPasswordCodeStatus: VerifyPasswordCodeStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          verifyPasswordCodeStatus: VerifyPasswordCodeStatus.success)),
    );
  }

  void _onResetPasswordRequest(
      ResetPasswordRequestEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(
        resetPasswordRequestStatus: ResetPasswordRequestStatus.loading,
        email: event.email));
    final result =
        await resetPasswordRequestUseCase(reset_password_request.Params(
      email: event.email,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          resetPasswordRequestStatus: ResetPasswordRequestStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          resetPasswordRequestStatus: ResetPasswordRequestStatus.success)),
    );
  }

  void _onResetPassword(
      ResetPasswordEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.loading));
    final result = await resetPasswordUseCase(reset_password.Params(
      email: state.email ?? '',
      password: event.password,
      code: state.code ?? '',
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          resetPasswordStatus: ResetPasswordStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(
          state.copyWith(resetPasswordStatus: ResetPasswordStatus.success)),
    );
  }

  void _onClearState(ClearStateEvent event, Emitter<UserState> emit) {
    emit(const UserState());
  }

  void _onSignOut(SignOutEvent event, Emitter<UserState> emit) async {
    final result = await signOutUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (success) => emit(const UserState()),
    );
  }

  void _onLoadCurrentUser(LoadCurrentUserEvent event, Emitter<UserState> emit) {
    loadCurrentUserUseCase(NoParams()).then((result) {
      result.fold(
        (failure) => emit(state.copyWith(
            errorMessage: failure.message,
            loadCurrentUserStatus: LoadCurrentUserStatus.failure)),
        (user) => emit(state.copyWith(
            loadCurrentUserStatus: LoadCurrentUserStatus.success, user: user)),
      );
    });
  }

  Future<String> _getBase64ImageFromFile(File image) async {
    final File imageFile = File(image.path);
    if (!imageFile.existsSync()) {
      return '';
    }
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String base64ImageWithPrefix = "data:image/png;base64,$base64Image";
    return base64ImageWithPrefix;
  }

  void _onMyProfile(UpdateProfileEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(myProfileStatus: MyProfileStatus.loading));
    bool isEmailVerified = state.user?.isEmailVerified ?? false;
    String? profilePictureBase64;
    if (event.profilePicture != null) {
      profilePictureBase64 =
          await _getBase64ImageFromFile(event.profilePicture!);
    }
    final result = await myProfileUseCase(my_profile.MyProfileParams(
      token: state.user?.token ?? '',
      firstName: event.firstName,
      lastName: event.lastName,
      latitude: event.latitude,
      longitude: event.longitude,
      phoneNumber: event.phoneNumber,
      street: event.street,
      subLocality: event.subLocality,
      subAdministrativeArea: event.subAdministrativeArea,
      postalCode: event.postalCode,
      profilePictureBase64: profilePictureBase64,
      gender: event.gender,
      dateOfBirth: event.dateOfBirth,
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
      productCategoryPreferences: event.productCategoryPreferences,
      productSizePreferences: event.productSizePreferences,
      productDesignPreferences: event.productDesignPreferences,
      productBrandPreferences: event.productBrandPreferences,
      productColorPreferences: event.productColorPreferences,
      notificationSetting: event.notificationSetting,
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          myProfileStatus: MyProfileStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          myProfileStatus: MyProfileStatus.success,
          user: success.copyWithObj(isEmailVerified: isEmailVerified))),
    );
  }

  void _onUpdateAccessToken(
      UpdateAccessTokenEvent event, Emitter<UserState> emit) async {
    bool isUpdateAccessToken = false;
    emit(state.copyWith(
        updateAccessTokenStatus: UpdateAccessTokenStatus.loading));
    final result = await updateAccessToken(update_access_token.Params(
      refeshToken: state.user?.refreshToken ?? 'xxx',
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          updateAccessTokenStatus: UpdateAccessTokenStatus.failure,
          errorMessage: failure.message)),
      (success) {
        isUpdateAccessToken = true;
        emit(state.copyWith(
            updateAccessTokenStatus: UpdateAccessTokenStatus.success,
            user: success));
      },
    );

    if (isUpdateAccessToken) {
      if (state.user?.tikTokAccessToken != null) {
        final result = await getTiktokerProfileDetailUseCase(
            get_tiktoker_profile_detail.Params(
                token: state.user?.tikTokAccessToken ?? ''));
        result.fold(
          (failure) => emit(state.copyWith(
              getTiktokerProfileDetailStatus:
                  GetTiktokerProfileDetailStatus.failure,
              errorMessage: failure.message)),
          (success) => emit(state.copyWith(
              getTiktokerProfileDetailStatus:
                  GetTiktokerProfileDetailStatus.success,
              tiktoker: success)),
        );
      }
    }
  }

  void _onLoginWithTiktok(
      LoginWithTiktokEvent event, Emitter<UserState> emit) async {
    bool isUpdateAccessToken = false;
    emit(state.copyWith(loginWithTiktokStatus: LoginWithTiktokStatus.loading));
    final result = await loginWithTiktokUsecase(
        login_with_tiktok.Params(accessCode: event.accessCode));
    result.fold(
        (failure) => emit(state.copyWith(
            loginWithTiktokStatus: LoginWithTiktokStatus.failure,
            errorMessage: failure.message)), (success) {
      isUpdateAccessToken = true;
      emit(state.copyWith(
          loginWithTiktokStatus: LoginWithTiktokStatus.success, user: success));
    });

    if (isUpdateAccessToken) {
      if (state.user?.tikTokAccessToken != null) {
        final result = await getTiktokerProfileDetailUseCase(
            get_tiktoker_profile_detail.Params(
                token: state.user?.tikTokAccessToken ?? ''));
        result.fold(
          (failure) => emit(state.copyWith(
              getTiktokerProfileDetailStatus:
                  GetTiktokerProfileDetailStatus.failure,
              errorMessage: failure.message)),
          (success) => emit(state.copyWith(
              getTiktokerProfileDetailStatus:
                  GetTiktokerProfileDetailStatus.success,
              tiktoker: success)),
        );
      }
    }
  }

  void _onRefereshTiktokAccessToken(
      RefereshTiktokAccessTokenEvent event, Emitter<UserState> emit) async {
    if (state.user?.tikTokRefreshToken == null) {
      return;
    }
    final result = await refereshTiktokAccessTokenUseCase(
        referesh_tiktok_access_token.Params(
      refreshCode: state.user?.tikTokRefreshToken ?? '',
    ));
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          updateAccessTokenStatus: UpdateAccessTokenStatus.success,
          user: success)),
    );
  }

  void _onDisConnectFromTiktok(
      DisConnectFromTiktokEvent event, Emitter<UserState> emit) async {
    if (state.user?.tikTokAccessToken == null) {
      return;
    }
    emit(state.copyWith(
        disConnectFromTiktokStatus: DisConnectFromTiktokStatus.loading));
    final result =
        await disConnectFromTiktokUseCase(dis_connect_from_tiktok.Params(
      tiktokAccessToken: state.user?.tikTokAccessToken ?? '',
      userAccessToken: state.user?.token ?? '',
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          disConnectFromTiktokStatus: DisConnectFromTiktokStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          disConnectFromTiktokStatus: DisConnectFromTiktokStatus.success,
          user: success,
          getTiktokerProfileDetailStatus:
              GetTiktokerProfileDetailStatus.initial)),
    );
  }

  void _onGetTiktokerProfileDetail(
      GetTiktokerInfoEvent event, Emitter<UserState> emit) async {
    if (state.user?.tikTokAccessToken == null) {
      return;
    }
    emit(state.copyWith(
        getTiktokerProfileDetailStatus:
            GetTiktokerProfileDetailStatus.loading));
    final result = await getTiktokerProfileDetailUseCase(
        get_tiktoker_profile_detail.Params(
      token: state.user?.tikTokAccessToken ?? '',
    ));
    result.fold(
      (failure) => emit(state.copyWith(
          getTiktokerProfileDetailStatus:
              GetTiktokerProfileDetailStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          getTiktokerProfileDetailStatus:
              GetTiktokerProfileDetailStatus.success,
          tiktoker: success)),
    );
  }

  void _onConnectToTiktok(
      ConnectToTiktokEvent event, Emitter<UserState> emit) async {
    if (state.user?.token == null) {
      return;
    }

    emit(state.copyWith(connectToTiktokStatus: ConnectToTiktokStatus.loading));

    final tiktokConnectResult = await connectFromTiktokUseCase(
      connect_from_tiktok.Params(
        tiktokAccessToken: event.accessCode,
        userAccessToken: state.user?.token ?? '',
      ),
    );

    tiktokConnectResult.fold(
      (failure) => emit(state.copyWith(
          connectToTiktokStatus: ConnectToTiktokStatus.failure,
          errorMessage: failure.message)),
      (success) => emit(state.copyWith(
          connectToTiktokStatus: ConnectToTiktokStatus.success, user: success)),
    );
  }

  void _onEmailVerified(EmailVerifiedEvent event, Emitter<UserState> emit) {
    emit(state.copyWith(
        user: state.user
            ?.copyWithObj(isEmailVerified: true, email: event.email)));
  }

  void _onRefereshAll(RefereshAllEvent event, Emitter<UserState> emit) {
    emit(state.copyWith(
        user: state.user?.copyWithObj(
      token: event.token,
    )));
  }
}
