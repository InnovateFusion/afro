import 'dart:convert';

import '../../models/product_model.dart';
import 'package:http/http.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../setUp/url/urls.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required String token,
    int? skip = 0,
    int? limit = 15,
  });

  Future<ProductModel> approvalReview({
    required String token,
    required String id,
    required int status,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts(
      {required String token, int? skip = 0, int? limit = 15}) async {
    String query = '?';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';

    final response = await client.get(
      Uri.parse(Urls.productReview + query),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final shops = jsonDecode(response.body) as List;
      return shops.map((shop) => ProductModel.fromJson(shop)).toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ProductModel> approvalReview(
      {required String token, required String id, required int status}) async {
    final response = await client.get(
      Uri.parse("${Urls.product}/$id/ApprovalReview/$status"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final shop = jsonDecode(response.body)['data'];
      return ProductModel.fromJson(shop);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }
}
