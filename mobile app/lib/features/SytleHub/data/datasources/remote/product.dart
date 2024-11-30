import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../setUp/url/urls.dart';
import '../../models/product/brand_model.dart';
import '../../models/product/category_model.dart';
import '../../models/product/color_model.dart';
import '../../models/product/design_model.dart';
import '../../models/product/domain_model.dart';
import '../../models/product/location_model.dart';
import '../../models/product/material_model.dart';
import '../../models/product/product_model.dart';
import '../../models/product/size_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ColorModel>> getColors();
  Future<List<BrandModel>> getBrands();
  Future<List<CategoryModel>> getCategories();
  Future<List<SizeModel>> getSizes();
  Future<List<MaterialModel>> getMaterials();
  Future<List<LocationModel>> getLocations();
  Future<List<DesignModel>> getDesigns();
  Future<List<DomainModel>> getDomains();
  Future<List<ProductModel>> getProducts({
    required String token,
    String? search,
    List<String>? colorIds,
    List<String>? sizeIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? materialIds,
    List<String>? designIds,
    bool? isNegotiable,
    bool? inStock,
    bool? isNew,
    bool? isDeliverable,
    double? minPrice,
    double? maxPrice,
    String? shopId,
    String? status,
    double? latitudes,
    double? longitudes,
    double? radiusInKilometers,
    String? condition,
    String? sortBy,
    String? sortOrder,
    int? skip = 0,
    int? limit = 15,
  });

  Future<List<ProductModel>> getFavoriteProducts(
      String token, int? skip, int? limit);

  Future<bool> shareProductToTikTok({
    required String accessToken,
    required String title,
    required String description,
    required bool disableComments,
    required bool duetDisabled,
    required bool stitchDisabled,
    required String privcayLevel,
    required bool autoAddMusic,
    required String source,
    required int photoCoverIndex,
    required List<String> photoImages,
    required String postMode,
    required String mediaType,
    required bool brandContentToggle,
    required bool brandOrganicToggle,
  });

  Future<File> removeBackground(
      {required String token, required File imageFile});

  Future<File> removeBackgroundFromUrl(
      {required String token, required String imageUrl});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ColorModel>> getColors() async {
    final response = await client.get(Uri.parse(Urls.color));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ColorModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<BrandModel>> getBrands() async {
    final response = await client.get(Uri.parse(Urls.brand));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => BrandModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.get(Uri.parse(Urls.category));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<MaterialModel>> getMaterials() async {
    final response = await client.get(Uri.parse(Urls.material));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => MaterialModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<SizeModel>> getSizes() async {
    final response = await client.get(Uri.parse(Urls.size));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => SizeModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<LocationModel>> getLocations() async {
    final response = await client.get(Uri.parse(Urls.location));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => LocationModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<DesignModel>> getDesigns() async {
    final response = await client.get(Uri.parse(Urls.design));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => DesignModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<DomainModel>> getDomains() async {
    final response = await client.get(Uri.parse(Urls.domain));
    if (response.statusCode == 200) {
      return DomainModel.fromJsonList(json.decode(response.body));
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ProductModel>> getProducts({
    required String token,
    String? search,
    List<String>? colorIds,
    List<String>? sizeIds,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? materialIds,
    List<String>? designIds,
    bool? isNegotiable,
    bool? inStock,
    bool? isNew,
    bool? isDeliverable,
    double? minPrice,
    double? maxPrice,
    String? shopId,
    String? status,
    double? latitudes,
    double? longitudes,
    double? radiusInKilometers,
    String? condition,
    String? sortBy,
    String? sortOrder,
    int? skip = 0,
    int? limit = 15,
  }) async {
    String query = '?';

    if (search != null) query += 'search=$search&';
    if (colorIds != null && colorIds.isNotEmpty) {
      for (var colorId in colorIds) {
        query += 'colorIds=$colorId&';
      }
    }
    if (sizeIds != null && sizeIds.isNotEmpty) {
      for (var sizeId in sizeIds) {
        query += 'sizeIds=$sizeId&';
      }
    }
    if (categoryIds != null && categoryIds.isNotEmpty) {
      for (var categoryId in categoryIds) {
        query += 'categoryIds=$categoryId&';
      }
    }

    if (designIds != null && designIds.isNotEmpty) {
      for (var designId in designIds) {
        query += 'designIds=$designId&';
      }
    }
    if (brandIds != null && brandIds.isNotEmpty) {
      for (var brandId in brandIds) {
        query += 'brandIds=$brandId&';
      }
    }
    if (materialIds != null && materialIds.isNotEmpty) {
      for (var materialId in materialIds) {
        query += 'materialIds=$materialId&';
      }
    }
    if (isNegotiable != null) {
      query += 'isNegotiable=$isNegotiable&';
    }

    if (isNew != null) {
      query += 'isNew=$isNew&';
    }

    if (isDeliverable != null) {
      query += 'isDeliverable=$isDeliverable&';
    }

    if (minPrice != null && minPrice != -1) query += 'minPrice=$minPrice&';
    if (maxPrice != null && maxPrice != -1) query += 'maxPrice=$maxPrice&';
    if (inStock != null) query += 'inStock=$inStock&';
    if (shopId != null) query += 'shopId=$shopId&';
    if (status != null) query += 'status=$status&';

    if (latitudes != null && latitudes != 0) query += 'latitudes=$latitudes&';
    if (longitudes != null && longitudes != 0) {
      query += 'longitudes=$longitudes&';
    }
    if (radiusInKilometers != null && radiusInKilometers != 0) {
      query += 'radiusInKilometers=$radiusInKilometers&';
    }
    if (condition != null) query += 'condition=$condition&';
    if (sortBy != null) query += 'sortBy=$sortBy&';
    if (sortOrder != null) query += 'sortOrder=$sortOrder&';
    if (skip != null) query += 'skip=$skip&';
    if (limit != null) query += 'limit=$limit&';

    final uri = Uri.parse(Urls.product + query);
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts(
      String token, int? skip, int? limit) async {
    final response =
        await client.get(Uri.parse(Urls.favoriteProduct), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } else {
      throw ServerException(
          message: json.decode(response.body)['Message'],
          statusCode: response.statusCode);
    }
  }

  @override
  Future<bool> shareProductToTikTok(
      {required String accessToken,
      required String title,
      required String description,
      required bool disableComments,
      required bool duetDisabled,
      required bool stitchDisabled,
      required String privcayLevel,
      required bool autoAddMusic,
      required String source,
      required int photoCoverIndex,
      required List<String> photoImages,
      required String postMode,
      required String mediaType,
      required bool brandContentToggle,
      required bool brandOrganicToggle}) async {
    String data = '';

    if (postMode == 'MEDIA_UPLOAD') {
      data = json.encode({
        "post_info": {
          "title": title,
          "description": description,
        },
        "source_info": {
          "source": source,
          "photo_cover_index": photoCoverIndex,
          "photo_images": photoImages,
        },
        "post_mode": postMode,
        "media_type": mediaType,
      });
    } else {
      data = json.encode({
        "post_info": {
          "title": title,
          "description": description,
          "disable_comment": disableComments,
          "duet_disabled": duetDisabled,
          "stitch_disabled": stitchDisabled,
          "privacy_level": privcayLevel,
          "auto_add_music": autoAddMusic,
          "brand_content_toggle": brandContentToggle,
          "brand_organic_toggle": brandOrganicToggle,
        },
        "source_info": {
          "source": source,
          "photo_cover_index": photoCoverIndex,
          "photo_images": photoImages,
        },
        "post_mode": postMode,
        "media_type": mediaType,
      });
    }

    final response = await client.post(
      Uri.parse(Urls.tiktokAuthUrl2),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: data,
    );

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw ServerException(
          message: "Error sharing product to TikTok",
          statusCode: response.statusCode);
    }
  }

  @override
  Future<File> removeBackground({
    required String token,
    required File imageFile,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${Urls.baseUrl}/Image/Remove-Background"));

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'png'),
    ));

    var response = await client.send(request);

    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();
      final tempDir = await getTemporaryDirectory();
      final name = const Uuid().v4();
      final tempFile = File('${tempDir.path}/$name.png');

      await tempFile.writeAsBytes(bytes);

      return tempFile;
    } else {
      throw ServerException(
        message: "Error removing background",
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<File> removeBackgroundFromUrl({
    required String token,
    required String imageUrl,
  }) async {
    final response = await client.post(
      Uri.parse('${Urls.baseUrl}/Image/Remove-Background-From-Url'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final name = const Uuid().v4();
      final tempFile = File('${tempDir.path}/$name.png');

      await tempFile.writeAsBytes(bytes);

      return tempFile;
    } else {
      throw ServerException(
        message: "Error removing background",
        statusCode: response.statusCode,
      );
    }
  }
}
