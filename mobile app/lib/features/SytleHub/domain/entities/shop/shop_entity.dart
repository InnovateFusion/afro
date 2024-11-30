import 'package:equatable/equatable.dart';

import '../product/image_entity.dart';
import '../product/product_entity.dart';
import 'review_entity.dart';
import 'working_hour_entity.dart';

class ShopEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> categories;
  final double rating;
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
  final bool isFollowing;
  final DateTime lastSeenAt;
  final String? website;
  final String userId;
  final Map<String, ProductEntity> products;
  final List<String> videos;
  final Map<String, ReviewEntity> reviews;
  final List<WorkingHourEntity> workingHours;
  final Map<String, ImageEntity> images;

  const ShopEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.categories,
    required this.rating,
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
    required this.isFollowing,
    required this.active,
    required this.lastSeenAt,
    required this.userId,
    required this.products,
    required this.videos,
    required this.reviews,
    required this.workingHours,
    required this.images,
    this.banner,
    this.website,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categories,
        rating,
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
        isFollowing,
        active,
        lastSeenAt,
        website,
        userId,
        products,
        videos,
        reviews,
        workingHours,
        images,
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
    Map<String, ProductEntity>? products,
    List<String>? videos,
    Map<String, ReviewEntity>? reviews,
    List<WorkingHourEntity>? workingHours,
    Map<String, ImageEntity>? images,
  }) {
    return ShopEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
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
      isFollowing: isFollowing ?? this.isFollowing,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      website: website ?? this.website,
      userId: userId ?? this.userId,
      products: products ?? this.products,
      videos: videos ?? this.videos,
      reviews: reviews ?? this.reviews,
      workingHours: workingHours ?? this.workingHours,
      images: images ?? this.images,
    );
  }
}
