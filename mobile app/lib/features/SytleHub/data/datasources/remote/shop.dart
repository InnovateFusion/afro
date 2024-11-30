import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../../../../core/errors/exception.dart';
import '../../../../../setUp/url/urls.dart';
import '../../models/product/image_model.dart';
import '../../models/product/product_model.dart';
import '../../models/shop/analytic_product_model.dart';
import '../../models/shop/analytic_shop_model.dart';
import '../../models/shop/review_model.dart';
import '../../models/shop/shop_model.dart';
import '../../models/shop/working_hour_model.dart';

abstract class ShopRemoteDataSource {
  Future<List<ShopModel>> getShop({
    required String token,
    String? search,
    List<String>? category,
    int? rating,
    int? verified,
    bool? active,
    String? ownerId,
    double? latitudes,
    double? longitudes,
    double? radiusInKilometers,
    String? condition,
    String? sortBy,
    String? sortOrder,
    int? skip,
    int? limit,
  });

  Future<ShopModel> getShopById({
    required String id,
  });

  Future<List<ImageModel>> getShopProductsImages({
    required String shopId,
    int? skip,
    int? limit,
  });

  Future<List<String>> getShopProductsVideos({
    required String shopId,
    int? skip,
    int? limit,
  });

  Future<List<ReviewModel>> getShopReviews({
    required String shopId,
    String? userId,
    String? sortBy,
    String? sortOrder,
    int? rating,
    int? skip,
    int? limit,
  });

  Future<List<ProductModel>> getShopProducts({
    required String token,
    required String shopId,
    String? sortBy,
    String? sortOrder,
    int? skip,
    int? limit,
  });

  Future<List<ProductModel>> getFollowingShopProducts({
    required String token,
    int? skip,
    int? limit,
  });

  Future<List<WorkingHourModel>> getShopWorkingHours({
    required String shopId,
  });

  Future<ProductModel> addProduct({
    required String token,
    required String title,
    required String description,
    required int price,
    required bool inStock,
    required bool isNew,
    required bool isDeliverable,
    required int availableQuantity,
    required bool isNegotiable,
    required String shopId,
    required String status,
    required List<String> images,
    required List<String> colorIds,
    required List<String> sizeIds,
    required List<String> categoryIds,
    required List<String> brandIds,
    required List<String> materialIds,
    required List<String> designIds,
    String? videoUrl,
  });

  Future<ImageModel> addProductImage({
    required String token,
    required String base64Image,
  });

  Future<ProductModel> deleteProductById({
    required String token,
    required String productId,
  });

  Future<String> addOrRemoveProductFromFavorite({
    required String token,
    required String productId,
  });

  Future<ProductModel> updateProduct({
    required String token,
    required String id,
    String? title,
    String? description,
    int? price,
    bool? isNew,
    bool? isDeliverable,
    int? availableQuantity,
    bool? isNegotiable,
    bool? inStock,
    String? shopId,
    String? status,
    List<String>? images,
    List<String>? colorIds,
    List<String>? sizeIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? materialIds,
    List<String>? designIds,
    String? videoUrl,
  });

  Future<ReviewModel> addReview({
    required String token,
    required String shopId,
    required String review,
    required int rating,
  });

  Future<ReviewModel> updateReview({
    required String token,
    required String reviewId,
    required String review,
    required int rating,
  });

  Future<ReviewModel> deleteReview({
    required String token,
    required String reviewId,
  });

  Future<AnalyticShopModel> getShopAnalytic({
    required String id,
    required String token,
  });

  Future<ShopModel> createShop({
    required String token,
    required String name,
    required String description,
    required String street,
    required String subLocality,
    required String subAdministrativeArea,
    required String postalCode,
    required double latitude,
    required double longitude,
    required String phone,
    required String logo,
    required List<String> categories,
    required Map<String, String> socialMedia,
    String? website,
  });

  Future<WorkingHourModel> addWorkingHour({
    required String token,
    required String shopId,
    required String day,
    required String time,
  });

  Future<WorkingHourModel> updateWorkingHour({
    required String token,
    required String id,
    required String day,
    required String time,
  });

  Future<ShopModel> updateShop({
    required String token,
    required String id,
    String? name,
    String? description,
    String? street,
    String? subLocality,
    String? subAdministrativeArea,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? banner,
    String? logo,
    List<String>? categories,
    Map<String, String>? socialMedia,
    String? website,
  });

  Future<WorkingHourModel> deleteWorkingHour({
    required String token,
    required String id,
  });

  Future<ShopModel> deleteShop({
    required String token,
    required String id,
  });

  Future<AnalyticProductModel> getProductAnalytic({
    required String token,
    required String id,
  });

  Future<bool> followOrUnfollowShop(
      {required String token, required String id});

  Future<String> makeContact({required String token, required String id});

  Future<ProductModel> getShopProductsById({required String productId});

  Future<ShopModel> requestShopVerification(
      {required String token,
      required String id,
      required String ownerIdentityCardUrl,
      required String businessRegistrationNumber,
      required String businessRegistrationDocumentUrl,
      required String ownerSelfieUrl});
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final Client client;

  ShopRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ShopModel>> getShop({
    required String token,
    String? search,
    List<String>? category,
    int? rating,
    int? verified,
    bool? active,
    String? ownerId,
    double? latitudes,
    double? longitudes,
    double? radiusInKilometers,
    String? condition,
    String? sortBy,
    String? sortOrder,
    int? skip,
    int? limit,
  }) async {
    String query = '?';

    if (search != null) query += 'search=$search&';
    if (category != null && category.isNotEmpty) {
      for (var categoryId in category) {
        query += 'category=$categoryId&';
      }
    }
    if (rating != null) query += 'rating=$rating&';
    if (verified != null) query += 'verified=$verified&';
    if (active != null) query += 'active=$active&';
    if (ownerId != null) query += 'ownerId=$ownerId&';
    if (latitudes != null) query += 'latitude=$latitudes&';
    if (longitudes != null) query += 'longitude=$longitudes&';
    if (radiusInKilometers != null) {
      query += 'radiusInKilometers=$radiusInKilometers&';
    }
    if (condition != null) query += 'condition=$condition&';
    if (sortBy != null) query += 'sortBy=$sortBy&';
    if (sortOrder != null) query += 'sortOrder=$sortOrder&';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';

    final response = await client.get(
      Uri.parse(Urls.shop + query),
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

  @override
  Future<List<ProductModel>> getShopProducts(
      {required String token,
      required String shopId,
      String? sortBy,
      String? sortOrder,
      int? skip,
      int? limit}) async {
    String query = '?';
    query += 'shopId=$shopId&';
    if (sortBy != null) query += 'sortBy=$sortBy&';
    if (sortOrder != null) query += 'sortOrder=$sortOrder&';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';
    final url = Uri.parse(Urls.product + query);
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final products = jsonDecode(response.body) as List;
      return products.map((product) => ProductModel.fromJson(product)).toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ImageModel>> getShopProductsImages(
      {required String shopId, int? skip, int? limit}) async {
    String query = '?';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';

    final response = await client.get(
      Uri.parse('${Urls.shop}/$shopId/products/images$query'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final images = jsonDecode(response.body) as List;
      return images.map((image) => ImageModel.fromJson(image)).toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<String>> getShopProductsVideos(
      {required String shopId, int? skip, int? limit}) async {
    String query = '?';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';

    final response = await client.get(
      Uri.parse('${Urls.shop}/$shopId/products/videos"$query'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final videos = jsonDecode(response.body) as List;
      return videos.map((video) => video.toString()).toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ReviewModel>> getShopReviews(
      {required String shopId,
      String? userId,
      String? sortBy,
      String? sortOrder,
      int? rating,
      int? skip,
      int? limit}) async {
    String query = '?';
    if (userId != null) query += 'userId=$userId&';
    if (sortBy != null) query += 'sortBy=$sortBy&';
    if (sortOrder != null) query += 'sortOrder=$sortOrder&';
    if (rating != null) query += 'rating=$rating&';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';

    final response = await client.get(
      Uri.parse('${Urls.review}/all/$shopId$query'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final reviews = jsonDecode(response.body) as List;
      return reviews.map((review) => ReviewModel.fromJson(review)).toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<WorkingHourModel>> getShopWorkingHours(
      {required String shopId}) async {
    final response = await client.get(
      Uri.parse('${Urls.workingHour}/$shopId/shop'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final workingHours = jsonDecode(response.body) as List;
      return workingHours
          .map((workingHour) => WorkingHourModel.fromJson(workingHour))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ShopModel> getShopById({required String id}) async {
    final response = await client.get(
      Uri.parse('${Urls.shop}/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ShopModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ProductModel> addProduct(
      {required String token,
      required String title,
      required String description,
      required int price,
      required bool inStock,
      required bool isNew,
      required bool isDeliverable,
      required int availableQuantity,
      required bool isNegotiable,
      required String shopId,
      required String status,
      required List<String> images,
      required List<String> colorIds,
      required List<String> sizeIds,
      required List<String> categoryIds,
      required List<String> brandIds,
      required List<String> materialIds,
      required List<String> designIds,
      String? videoUrl}) async {
    final response = await client.post(Uri.parse(Urls.product),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "price": price,
          "status": status,
          "videoUrl": videoUrl,
          "shopId": shopId,
          "isNegotiable": isNegotiable,
          "isNew": isNew,
          "isDeliverable": isDeliverable,
          "availableQuantity": availableQuantity,
          "inStock": inStock,
          "imageIds": images,
          "categoryIds": categoryIds,
          "brandIds": brandIds,
          "designIds": designIds,
          "sizeIds": sizeIds,
          "colorIds": colorIds,
          "materialIds": materialIds
        }));
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ImageModel> addProductImage(
      {required String token, required String base64Image}) async {
    final response = await client.post(
      Uri.parse(Urls.image),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {"base64Image": base64Image},
      ),
    );

    if (response.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ProductModel> deleteProductById(
      {required String token, required String productId}) async {
    final response = await client.delete(
      Uri.parse('${Urls.product}/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<String> addOrRemoveProductFromFavorite(
      {required String token, required String productId}) async {
    final response = await client
        .post(Uri.parse('${Urls.product}/favourite/$productId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ProductModel> updateProduct({
    required String token,
    required String id,
    String? title,
    String? description,
    int? price,
    bool? isNew,
    bool? isDeliverable,
    int? availableQuantity,
    bool? isNegotiable,
    bool? inStock,
    String? shopId,
    String? status,
    List<String>? images,
    List<String>? colorIds,
    List<String>? sizeIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? materialIds,
    List<String>? designIds,
    String? videoUrl,
  }) async {
    final response = await client.put(Uri.parse('${Urls.product}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "price": price,
          "status": status,
          "videoUrl": videoUrl,
          "shopId": shopId,
          "isNegotiable": isNegotiable,
          "isNew": isNew,
          "isDeliverable": isDeliverable,
          "availableQuantity": availableQuantity,
          "inStock": inStock,
          "imageIds": images,
          "categoryIds": categoryIds,
          "brandIds": brandIds,
          "designIds": designIds,
          "sizeIds": sizeIds,
          "colorIds": colorIds,
          "materialIds": materialIds
        }));

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ReviewModel> addReview(
      {required String token,
      required String shopId,
      required String review,
      required int rating}) async {
    final response = await client.post(Uri.parse(Urls.review),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body:
            jsonEncode({"shopId": shopId, "review": review, "rating": rating}));

    if (response.statusCode == 200) {
      return ReviewModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ReviewModel> updateReview(
      {required String token,
      required String reviewId,
      required String review,
      required int rating}) async {
    final response = await client.put(Uri.parse(Urls.review),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body:
            jsonEncode({"id": reviewId, "comment": review, "rating": rating}));

    if (response.statusCode == 200) {
      return ReviewModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ReviewModel> deleteReview(
      {required String token, required String reviewId}) async {
    final response =
        await client.delete(Uri.parse('${Urls.review}/$reviewId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return ReviewModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<AnalyticShopModel> getShopAnalytic(
      {required String id, required String token}) async {
    final response = await client.get(
      Uri.parse('${Urls.shop}/$id/analytics'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return AnalyticShopModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ShopModel> createShop(
      {required String token,
      required String name,
      required String description,
      required String street,
      required String subLocality,
      required String subAdministrativeArea,
      required String postalCode,
      required double latitude,
      required double longitude,
      required String phone,
      required String logo,
      required List<String> categories,
      required Map<String, String> socialMedia,
      String? website}) async {
    final response = await client.post(Uri.parse(Urls.shop),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'street': street,
          'subLocality': subLocality,
          'subAdministrativeArea': subAdministrativeArea,
          'postalCode': postalCode,
          'latitude': latitude,
          'longitude': longitude,
          'phoneNumber': phone,
          'website': website,
          'logo': logo,
          'categories': categories,
          'socialMediaLinks': socialMedia
        }));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ShopModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<WorkingHourModel> addWorkingHour(
      {required String token,
      required String shopId,
      required String day,
      required String time}) async {
    final response = await client.post(Uri.parse(Urls.workingHour),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({"shopId": shopId, "day": day, "time": time}));

    if (response.statusCode == 200) {
      return WorkingHourModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ShopModel> updateShop(
      {required String token,
      required String id,
      String? name,
      String? description,
      String? street,
      String? subLocality,
      String? subAdministrativeArea,
      String? postalCode,
      double? latitude,
      double? longitude,
      String? phone,
      String? banner,
      String? logo,
      List<String>? categories,
      Map<String, String>? socialMedia,
      String? website}) async {
    final response = await client.put(Uri.parse('${Urls.shop}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "name": name,
          "description": description,
          "street": street,
          "subLocality": subLocality,
          "subAdministrativeArea": subAdministrativeArea,
          "postalCode": postalCode,
          "latitude": latitude,
          "longitude": longitude,
          "phone": phone,
          "banner": banner,
          "logo": logo,
          "category": categories,
          "socialMediaLinks": socialMedia,
          "website": website
        }));

    if (response.statusCode == 200) {
      return ShopModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<WorkingHourModel> updateWorkingHour(
      {required String token,
      required String id,
      required String day,
      required String time}) async {
    final response = await client.put(Uri.parse(Urls.workingHour),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({"day": day, "time": time, "id": id}));

    if (response.statusCode == 200) {
      return WorkingHourModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<WorkingHourModel> deleteWorkingHour(
      {required String token, required String id}) async {
    final response = await client.delete(Uri.parse('${Urls.workingHour}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      return WorkingHourModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ShopModel> deleteShop(
      {required String token, required String id}) async {
    final response = await client.delete(Uri.parse('${Urls.shop}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      return ShopModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<AnalyticProductModel> getProductAnalytic(
      {required String token, required String id}) async {
    final response = await client
        .get(Uri.parse('${Urls.product}/$id/analytics'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return AnalyticProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<bool> followOrUnfollowShop(
      {required String token, required String id}) async {
    final response = await client
        .get(Uri.parse('${Urls.shop}/$id/follow-or-unfollow'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<String> makeContact(
      {required String token, required String id}) async {
    final response = await client
        .post(Uri.parse('${Urls.product}/$id/contacted'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return Future.value('Contacted');
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ProductModel>> getFollowingShopProducts(
      {required String token, int? skip, int? limit}) async {
    String query = '?';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';
    final response = await client.get(
      Uri.parse('${Urls.shop}/products/followed$query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final products = jsonDecode(response.body) as List;
      return products.map((product) => ProductModel.fromJson(product)).toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ProductModel> getShopProductsById({required String productId}) async {
    final response = await client.get(
      Uri.parse('${Urls.product}/$productId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<ShopModel> requestShopVerification(
      {required String token,
      required String id,
      required String ownerIdentityCardUrl,
      required String businessRegistrationNumber,
      required String businessRegistrationDocumentUrl,
      required String ownerSelfieUrl}) async {
    final response = await client.post(Uri.parse('${Urls.shop}/Verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "id": id,
          "ownerIdentityCardUrl": ownerIdentityCardUrl,
          "businessRegistrationNumber": businessRegistrationNumber,
          "businessRegistrationDocumentUrl": businessRegistrationDocumentUrl,
          "ownerSelfieUrl": ownerSelfieUrl
        }));

    if (response.statusCode == 200) {
      return ShopModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }
}
