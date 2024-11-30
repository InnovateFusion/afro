abstract class Urls {
  // Base URL
  static const String baseUrl = 'http://afrostore.bisry.me:5130/api';
  static const String socketIp = 'http://afrostore.bisry.me:5130/chatHub';

  // Product
  static const String color = '$baseUrl/Color';
  static const String product = '$baseUrl/Product';
  static const String category = '$baseUrl/Category';
  static const String brand = '$baseUrl/Brand';
  static const String size = '$baseUrl/Size';
  static const String material = '$baseUrl/Material';
  static const String location = '$baseUrl/Location';
  static const String design = '$baseUrl/Design';
  static const String domain = '$baseUrl/Category/domain/detail';
  static const String favoriteProduct = '$baseUrl/Product/favourite';
  static const String updateAccessTokens =
      '$baseUrl/Authentication/Refresh-Token';

  // User
  static const String signIn = '$baseUrl/Authentication/Login';
  static const String signUp = '$baseUrl/Authentication/Register';
  static const String sendVerificationCode =
      '$baseUrl/Authentication/Send-Verfication-Email-Code';
  static const String verifyCode = '$baseUrl/Authentication/Verify-Email';
  static const String resetPasswordRequest =
      '$baseUrl/Authentication/Send-Reset-Password-Code';
  static const String resetPassword = '$baseUrl/Authentication/Reset-Password';
  static const String resetPasswordCodeVerification =
      '$baseUrl/Authentication/Verify-Password-Reset-Code';
  static const String user = '$baseUrl/User';

  static const String loginWithTiktok =
      '$baseUrl/Authentication/Login-With-TikTok';
  static const String refereshTiktok =
      '$baseUrl/Authentication/Refresh-TikTok-Access-Token';
  static const String connectFromTiktok =
      '$baseUrl/Authentication/Connect-With-TikTok';
  static const String disConnectFromTiktok =
      '$baseUrl/Authentication/Disconnect-TikTok';

  // Shop
  static const String shop = '$baseUrl/Shop';

  // Review
  static const String review = '$baseUrl/Review';

  // Working Hour
  static const String workingHour = '$baseUrl/WorkingHour';

  // Image
  static const String image = '$baseUrl/Image';

  // Chat
  static const String chat = '$baseUrl/Chat';

  static const String notification = '$baseUrl/Notification';

  static const String dummyImage =
      'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

  static const String tiktokAuthUrl =
      'https://open.tiktokapis.com/v2/user/info/?fields=open_id,union_id,avatar_url,avatar_url_100,avatar_large_url,display_name,bio_description,profile_deep_link,is_verified,username,follower_count,following_count,likes_count,video_count';

  static const String tiktokAuthUrl2 =
      "https://open.tiktokapis.com/v2/post/publish/content/init/";

  static const String sendProfileVerificationCode =
      "$baseUrl/Authentication/Profile-Email-Verification-Code";

  static const String verifyProfileCode =
      "$baseUrl/Authentication/Verify-Profile-Email";

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.app';

  static const String appVersion = '1.0.0';
}
