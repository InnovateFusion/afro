import 'dart:convert';

import 'package:http/http.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../setUp/url/urls.dart';
import '../../models/shop_model.dart';

abstract class ShopRemoteDataSource {
  Future<List<ShopModel>> getShops({
    required String token,
    int? skip = 0,
    int? limit = 15,
  });
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final Client client;

  ShopRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ShopModel>> getShops(
      {required String token, int? skip = 0, int? limit = 15}) async {
    String query = '?';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';

    final response = await client.get(
      Uri.parse(Urls.shopReview + query),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final shops = jsonDecode(response.body) as List;
      return shops.map((shop) => ShopModel.fromJson(shop)).toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }
}
