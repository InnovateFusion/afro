import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/internet.dart';
import 'features/SytleHub/data/datasources/local/user.dart';
import 'features/SytleHub/data/datasources/remote/chat.dart';
import 'features/SytleHub/data/datasources/remote/product.dart';
import 'features/SytleHub/data/datasources/remote/shop.dart';
import 'features/SytleHub/data/datasources/remote/user.dart';
import 'features/SytleHub/data/repositories/chat.dart';
import 'features/SytleHub/data/repositories/product.dart';
import 'features/SytleHub/data/repositories/shop.dart';
import 'features/SytleHub/data/repositories/user.dart';
import 'features/SytleHub/domain/repositories/chat.dart';
import 'features/SytleHub/domain/repositories/product.dart';
import 'features/SytleHub/domain/repositories/shop.dart';
import 'features/SytleHub/domain/repositories/user.dart';
import 'features/SytleHub/domain/usecases/chat/delete_chat_usecase.dart';
import 'features/SytleHub/domain/usecases/chat/get_chat_participants_usecase.dart';
import 'features/SytleHub/domain/usecases/chat/get_chat_participants_with_last_message_usecase.dart';
import 'features/SytleHub/domain/usecases/chat/get_chat_usecase.dart';
import 'features/SytleHub/domain/usecases/chat/get_chats_usecase.dart';
import 'features/SytleHub/domain/usecases/chat/mark_chat_as_read_usecase.dart';
import 'features/SytleHub/domain/usecases/chat/realtime_chat_response_usecase.dart';
import 'features/SytleHub/domain/usecases/chat/send_message_usecase.dart';
import 'features/SytleHub/domain/usecases/product/background_remover.dart';
import 'features/SytleHub/domain/usecases/product/background_remover_from_url.dart';
import 'features/SytleHub/domain/usecases/product/get_brand.dart';
import 'features/SytleHub/domain/usecases/product/get_category.dart';
import 'features/SytleHub/domain/usecases/product/get_color.dart';
import 'features/SytleHub/domain/usecases/product/get_design.dart';
import 'features/SytleHub/domain/usecases/product/get_domain.dart';
import 'features/SytleHub/domain/usecases/product/get_favorite.dart';
import 'features/SytleHub/domain/usecases/product/get_location.dart';
import 'features/SytleHub/domain/usecases/product/get_material.dart';
import 'features/SytleHub/domain/usecases/product/get_product.dart';
import 'features/SytleHub/domain/usecases/product/get_size.dart';
import 'features/SytleHub/domain/usecases/product/share_product_to_tiktok.dart';
import 'features/SytleHub/domain/usecases/shop/add_image.dart';
import 'features/SytleHub/domain/usecases/shop/add_or_remove_favorite.dart';
import 'features/SytleHub/domain/usecases/shop/add_product.dart';
import 'features/SytleHub/domain/usecases/shop/add_review.dart';
import 'features/SytleHub/domain/usecases/shop/add_working_hour.dart';
import 'features/SytleHub/domain/usecases/shop/create_shop.dart';
import 'features/SytleHub/domain/usecases/shop/delete_product.dart';
import 'features/SytleHub/domain/usecases/shop/delete_review.dart';
import 'features/SytleHub/domain/usecases/shop/delete_shop.dart';
import 'features/SytleHub/domain/usecases/shop/delete_working_hour.dart';
import 'features/SytleHub/domain/usecases/shop/follow_unfollow_shop.dart';
import 'features/SytleHub/domain/usecases/shop/get_following_shop_products.dart';
import 'features/SytleHub/domain/usecases/shop/get_product_by_id.dart';
import 'features/SytleHub/domain/usecases/shop/get_shop.dart';
import 'features/SytleHub/domain/usecases/shop/get_shop_by_id.dart';
import 'features/SytleHub/domain/usecases/shop/get_shop_products.dart';
import 'features/SytleHub/domain/usecases/shop/get_shop_products_images.dart';
import 'features/SytleHub/domain/usecases/shop/get_shop_products_video.dart';
import 'features/SytleHub/domain/usecases/shop/get_shop_reviews.dart';
import 'features/SytleHub/domain/usecases/shop/get_shop_working_hour.dart';
import 'features/SytleHub/domain/usecases/shop/make_contact.dart';
import 'features/SytleHub/domain/usecases/shop/product_analytic.dart';
import 'features/SytleHub/domain/usecases/shop/shop_analytic.dart';
import 'features/SytleHub/domain/usecases/shop/shop_verification_request.dart';
import 'features/SytleHub/domain/usecases/shop/update_product.dart';
import 'features/SytleHub/domain/usecases/shop/update_review.dart';
import 'features/SytleHub/domain/usecases/shop/update_shop.dart';
import 'features/SytleHub/domain/usecases/shop/update_working_hour.dart';
import 'features/SytleHub/domain/usecases/user/connect_from_tiktok.dart';
import 'features/SytleHub/domain/usecases/user/dis_connect_from_tiktok.dart';
import 'features/SytleHub/domain/usecases/user/get_notifications.dart';
import 'features/SytleHub/domain/usecases/user/get_tiktoker_profile_detail.dart';
import 'features/SytleHub/domain/usecases/user/get_user_by_id.dart';
import 'features/SytleHub/domain/usecases/user/get_users.dart';
import 'features/SytleHub/domain/usecases/user/load_currect_user.dart';
import 'features/SytleHub/domain/usecases/user/login_with_tiktok.dart';
import 'features/SytleHub/domain/usecases/user/mark_notificaition_as_read.dart';
import 'features/SytleHub/domain/usecases/user/my_profile.dart';
import 'features/SytleHub/domain/usecases/user/password_reset_verify_code.dart';
import 'features/SytleHub/domain/usecases/user/referesh_tiktok_access_token.dart';
import 'features/SytleHub/domain/usecases/user/reset_password.dart';
import 'features/SytleHub/domain/usecases/user/reset_password_request.dart';
import 'features/SytleHub/domain/usecases/user/send_profile_verification_code.dart';
import 'features/SytleHub/domain/usecases/user/send_verification_code.dart';
import 'features/SytleHub/domain/usecases/user/sign_in.dart';
import 'features/SytleHub/domain/usecases/user/sign_out.dart';
import 'features/SytleHub/domain/usecases/user/sign_up.dart';
import 'features/SytleHub/domain/usecases/user/update_access_token.dart';
import 'features/SytleHub/domain/usecases/user/verify_code.dart';
import 'features/SytleHub/domain/usecases/user/verify_profile_code.dart';
import 'features/SytleHub/presentation/bloc/chat/chat_bloc.dart';
import 'features/SytleHub/presentation/bloc/general/general_bloc.dart';
import 'features/SytleHub/presentation/bloc/notification/notification_bloc.dart';
import 'features/SytleHub/presentation/bloc/product/product_bloc.dart';
import 'features/SytleHub/presentation/bloc/shop/shop_bloc.dart';
import 'features/SytleHub/presentation/bloc/user/user_bloc.dart';
import 'setUp/service/signalr_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features

  // SignalR
  sl.registerSingleton<SignalRService>(SignalRService());

  // General
  sl.registerFactory(() => GeneralBloc(
        sendVerificationCodeUseCase: sl(),
        verifyCodeUseCase: sl(),
        sendProfileVerificationCodeUseCase: sl(),
        verifyProfileCodeUseCase: sl(),
      ));

  // - Product
  sl.registerFactory(() => ProductBloc(
        getDesignsUseCase: sl(),
        getColorsUseCase: sl(),
        getBrandsUseCase: sl(),
        getMaterialsUseCase: sl(),
        getSizesUseCase: sl(),
        getCategoriesUseCase: sl(),
        getLocationUseCase: sl(),
        getDomainsUseCase: sl(),
        myProfileUseCase: sl(),
        getProductUseCase: sl(),
        shareProductToTiktokUseCase: sl(),
        backgroundRemoverUseCase: sl(),
        backgroundRemoverFromUrlUseCase: sl(),
      ));

  // User
  sl.registerFactory(() => UserBloc(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        sendVerificationCodeUseCase: sl(),
        verifyCodeUseCase: sl(),
        resetPasswordRequestUseCase: sl(),
        resetPasswordUseCase: sl(),
        verifyPasswordCodeUseCase: sl(),
        loadCurrentUserUseCase: sl(),
        signOutUseCase: sl(),
        myProfileUseCase: sl(),
        updateAccessToken: sl(),
        loginWithTiktokUsecase: sl(),
        refereshTiktokAccessTokenUseCase: sl(),
        getTiktokerProfileDetailUseCase: sl(),
        disConnectFromTiktokUseCase: sl(),
        connectFromTiktokUseCase: sl(),
      ));

  // Shop
  sl.registerFactory(() => ShopBloc(
        getFollowingShopProductsUseCase: sl(),
        getProductsUseCase: sl(),
        getShopByIdUseCase: sl(),
        getShopProductsImageUseCase: sl(),
        getShopProductsVideoUseCase: sl(),
        getShopProductUseCase: sl(),
        getShopReviewUseCase: sl(),
        getShopWorkingHourUseCase: sl(),
        getShopUseCase: sl(),
        addImageUseCase: sl(),
        addProductsUseCase: sl(),
        deleteProductByIdUseCase: sl(),
        getFavoriteUseCase: sl(),
        addOrRemoveFavoriteUseCase: sl(),
        updateProductsUseCase: sl(),
        addReviewUseCase: sl(),
        updateReviewUseCase: sl(),
        deleteReviewUseCase: sl(),
        shopAnalyticUseCase: sl(),
        createShopUseCase: sl(),
        addWorkingHourUseCase: sl(),
        updateShopUseCase: sl(),
        updateWorkingHourUseCase: sl(),
        deleteWorkingHourUseCase: sl(),
        deleteShopUseCase: sl(),
        productAnalyticUseCase: sl(),
        makeContactUseCase: sl(),
        followUnfollowShopUseCase: sl(),
        shopVerificationRequestUseCase: sl(),
        getProductByIdUseCase: sl(),
      ));

  // Chat
  sl.registerFactory(() => ChatBloc(
        signalRService: sl(),
        getChatParticipantsUseCase: sl(),
        getChatsUsecase: sl(),
        getChatUsecase: sl(),
        deleteChatUsecase: sl(),
        sendMessageUsecase: sl(),
        realtimeChatResponseUsecase: sl(),
        getUserByIdUsecase: sl(),
        getChatParticipantsWithLastMessageUsecase: sl(),
        markChatAsReadUsecase: sl(),
        getUsersUsecase: sl(),
      ));

  sl.registerFactory(() => NotificationBloc(
        getNotificationsUsecase: sl(),
        markAsReadNotificationsUsecase: sl(),
        signalRService: sl(),
      ));

  // Use cases
  // - Product
  sl.registerLazySingleton(() => GetColorsUseCase(sl()));
  sl.registerLazySingleton(() => GetBrandsUseCase(sl()));
  sl.registerLazySingleton(() => GetMaterialsUseCase(sl()));
  sl.registerLazySingleton(() => GetSizesUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetLocationUseCase(sl()));
  sl.registerLazySingleton(() => GetDesignsUseCase(sl()));
  sl.registerLazySingleton(() => GetDomainsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => ShareProductToTiktokUseCase(sl()));
  sl.registerLazySingleton(() => BackgroundRemoverUseCase(sl()));
  sl.registerLazySingleton(() => BackgroundRemoverFromUrlUseCase(sl()));

  // - User
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SendVerificationCodeUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCodeUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordRequestUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => PasswordResetVerifyCodeUseCase(sl()));
  sl.registerLazySingleton(() => LoadCurrectUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => MyProfileUsecase(sl()));
  sl.registerLazySingleton(() => GetUserByIdUsecase(sl()));
  sl.registerLazySingleton(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton(() => UpdateAccessToken(sl()));
  sl.registerLazySingleton(() => LoginWithTiktokUsecase(sl()));
  sl.registerLazySingleton(() => RefereshTiktokAccessTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetTiktokerProfileDetailUseCase(sl()));
  sl.registerLazySingleton(() => DisConnectFromTiktokUseCase(sl()));
  sl.registerLazySingleton(() => ConnectFromTiktokUseCase(sl()));
  sl.registerLazySingleton(() => SendProfileVerificationCodeUseCase(sl()));
  sl.registerLazySingleton(() => VerifyProfileCodeUseCase(sl()));

  // - Shop
  sl.registerLazySingleton(() => GetShopByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetShopProductsImageUseCase(sl()));
  sl.registerLazySingleton(() => GetShopProductsVideoUseCase(sl()));
  sl.registerLazySingleton(() => GetShopProductUseCase(sl()));
  sl.registerLazySingleton(() => GetShopReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetShopWorkingHourUseCase(sl()));
  sl.registerLazySingleton(() => GetShopUseCase(sl()));
  sl.registerLazySingleton(() => AddImageUseCase(sl()));
  sl.registerLazySingleton(() => AddProductsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => AddOrRemoveFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddReviewUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewUseCase(sl()));
  sl.registerLazySingleton(() => ShopAnalyticUseCase(sl()));
  sl.registerLazySingleton(() => CreateShopUseCase(sl()));
  sl.registerLazySingleton(() => AddWorkingHourUseCase(sl()));
  sl.registerLazySingleton(() => UpdateShopUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWorkingHourUseCase(sl()));
  sl.registerLazySingleton(() => DeleteWorkingHourUseCase(sl()));
  sl.registerLazySingleton(() => DeleteShopUseCase(sl()));
  sl.registerLazySingleton(() => ProductAnalyticUseCase(sl()));
  sl.registerLazySingleton(() => MakeContactUseCase(sl()));
  sl.registerLazySingleton(() => FollowUnfollowShopUseCase(sl()));
  sl.registerLazySingleton(() => GetFollowingShopProducts(sl()));
  sl.registerLazySingleton(() => ShopVerificationRequestUsecase(sl()));

  // - Chat
  sl.registerLazySingleton(() => GetChatParticipantsUsecase(sl()));
  sl.registerLazySingleton(() => GetChatsUsecase(sl()));
  sl.registerLazySingleton(() => GetChatUsecase(sl()));
  sl.registerLazySingleton(() => DeleteChatUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => RealtimeChatResponseUsecase(sl()));
  sl.registerLazySingleton(
      () => GetChatParticipantsWithLastMessageUsecase(sl()));
  sl.registerLazySingleton(() => MarkChatAsReadUsecase(sl()));

  // Notifications
  sl.registerLazySingleton(() => GetNotificationsUsecase(sl()));
  sl.registerLazySingleton(() => MarkAsReadNotificationsUsecase(sl()));

  // Repository
  // - Product
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
        remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources - Remote
  // - Product
  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<ShopRemoteDataSource>(
      () => ShopRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: sl()));

  // Data sources - Local
  // - User
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
