import '../../../domain/entities/shop/shop_entity.dart';
import '../product/image_model.dart';
import '../product/product_model.dart';
import 'review_model.dart';
import 'working_hour_model.dart';

class ShopModel extends ShopEntity {
  const ShopModel({
    required super.id,
    required super.name,
    required super.description,
    required super.categories,
    required super.rating,
    required super.latitude,
    required super.longitude,
    required super.phoneNumber,
    required super.logo,
    required super.socialMediaLinks,
    required super.verificationStatus,
    required super.active,
    required super.isFollowing,
    required super.lastSeenAt,
    required super.userId,
    required super.products,
    required super.videos,
    required super.reviews,
    required super.workingHours,
    required super.images,
    super.website,
    super.banner,
    required super.street,
    required super.subLocality,
    required super.subAdministrativeArea,
    required super.postalCode,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    List<String> categories = [];
    if (json.containsKey('categories')) {
      categories = List<String>.from(json['categories']);
    }

    Map<String, String> socialMediaLinks = {};
    if (json.containsKey('socialMediaLinks')) {
      json['socialMediaLinks'].forEach((key, value) {
        socialMediaLinks[key] = value;
      });
    }

    return ShopModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categories: categories,
      rating: json['rating'].toDouble(),
      street: json['street'],
      subLocality: json['subLocality'],
      subAdministrativeArea: json['subAdministrativeArea'],
      postalCode: json['postalCode'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      phoneNumber: json['phoneNumber'],
      banner: json['banner'],
      logo: json['logo'],
      socialMediaLinks: socialMediaLinks,
      verificationStatus: json['verificationStatus'],
      active: json['active'],
      isFollowing: json['isFollowing'],
      lastSeenAt: DateTime.parse(json['lastSeenAt']),
      website: json['website'],
      userId: json['userId'],
      products: json.containsKey('products')
          ? Map<String, ProductModel>.from(json['products']
              .map((key, value) => MapEntry(key, ProductModel.fromJson(value))))
          : {},
      videos:
          json.containsKey('videos') ? List<String>.from(json['videos']) : [],
      reviews: json.containsKey('reviews')
          ? Map<String, ReviewModel>.from(json['reviews']
              .map((key, value) => MapEntry(key, ProductModel.fromJson(value))))
          : {},
      workingHours: json.containsKey('workingHours')
          ? List<WorkingHourModel>.from(
              json['workingHours'].map((e) => WorkingHourModel.fromJson(e)))
          : [],
      images: json.containsKey('images')
          ? Map<String, ImageModel>.from(json['images']
              .map((key, value) => MapEntry(key, ImageModel.fromJson(value))))
          : {},
    );
  }
}
