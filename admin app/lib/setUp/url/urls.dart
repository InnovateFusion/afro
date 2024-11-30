abstract class Urls {
  // Base URL
  static const String baseUrl = 'http://afrostore.bisry.me:5130/api';
  static const String socketIp = 'http://afrostore.bisry.me:5130/chatHub';
  static const String product = '$baseUrl/Product';
  static const String updateAccessTokens =
      '$baseUrl/Authentication/Refresh-Token';
  static const String signIn = '$baseUrl/Authentication/Login';
  static const String productReview = '$baseUrl/Product/Reviews';
  static const String shopReview = '$baseUrl/Shop/Verify';
}
