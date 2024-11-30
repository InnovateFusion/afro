import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> categories;
  final String street;
  final String subLocality;
  final String subAdministrativeArea;
  final String postalCode;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String? banner;
  final String logo;
  final Map<String, String> socialMediaLinks;
  final int verificationStatus;
  final bool active;
  final DateTime lastSeenAt;
  final String? website;
  final String userId;
  final String ownerIdentityCardUrl;
  final String businessRegistrationNumber;
  final String businessRegistrationDocumentUrl;
  final String ownerSelfieUrl;

  const ShopEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.categories,
    required this.street,
    required this.subLocality,
    required this.subAdministrativeArea,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.logo,
    required this.socialMediaLinks,
    required this.verificationStatus,
    required this.active,
    required this.lastSeenAt,
    required this.userId,
    required this.ownerIdentityCardUrl,
    required this.businessRegistrationNumber,
    required this.businessRegistrationDocumentUrl,
    required this.ownerSelfieUrl,
    this.banner,
    this.website,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categories,
        street,
        subLocality,
        subAdministrativeArea,
        postalCode,
        latitude,
        longitude,
        phoneNumber,
        banner,
        logo,
        socialMediaLinks,
        verificationStatus,
        active,
        lastSeenAt,
        website,
        userId,
        ownerIdentityCardUrl,
        businessRegistrationNumber,
        businessRegistrationDocumentUrl,
        ownerSelfieUrl,
      ];

  ShopEntity copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? categories,
    double? rating,
    String? street,
    String? subLocality,
    String? subAdministrativeArea,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    String? banner,
    String? logo,
    Map<String, String>? socialMediaLinks,
    int? verificationStatus,
    bool? active,
    bool? isFollowing,
    DateTime? lastSeenAt,
    String? website,
    String? userId,
    String? ownerIdentityCardUrl,
    String? businessRegistrationNumber,
    String? businessRegistrationDocumentUrl,
    String? ownerSelfieUrl,

  }) {
    return ShopEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      street: street ?? this.street,
      subLocality: subLocality ?? this.subLocality,
      subAdministrativeArea:
          subAdministrativeArea ?? this.subAdministrativeArea,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      banner: banner ?? this.banner,
      logo: logo ?? this.logo,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      active: active ?? this.active,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      website: website ?? this.website,
      userId: userId ?? this.userId,
      ownerIdentityCardUrl: ownerIdentityCardUrl ?? this.ownerIdentityCardUrl,
      businessRegistrationNumber:
          businessRegistrationNumber ?? this.businessRegistrationNumber,
      businessRegistrationDocumentUrl: businessRegistrationDocumentUrl ??
          this.businessRegistrationDocumentUrl,
      ownerSelfieUrl: ownerSelfieUrl ?? this.ownerSelfieUrl,
    );
  }
}
