import '../../domain/entities/shop_entity.dart';

class ShopModel extends ShopEntity {
  const ShopModel({
    required super.id,
    required super.name,
    required super.description,
    required super.categories,
    required super.latitude,
    required super.longitude,
    required super.phoneNumber,
    required super.logo,
    required super.socialMediaLinks,
    required super.verificationStatus,
    required super.active,
    required super.lastSeenAt,
    required super.userId,
    super.website,
    super.banner,
    required super.street,
    required super.subLocality,
    required super.subAdministrativeArea,
    required super.postalCode,
    required super.ownerSelfieUrl,
    required super.businessRegistrationDocumentUrl,
    required super.businessRegistrationNumber,
    required super.ownerIdentityCardUrl,
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
      lastSeenAt: DateTime.parse(json['lastSeenAt']),
      website: json['website'],
      userId: json['userId'],
      ownerIdentityCardUrl: json['ownerIdentityCardUrl'],
      businessRegistrationNumber: json['businessRegistrationNumber'],
      businessRegistrationDocumentUrl: json['businessRegistrationDocumentUrl'],
      ownerSelfieUrl: json['ownerSelfieUrl'],
    );
  }
}
