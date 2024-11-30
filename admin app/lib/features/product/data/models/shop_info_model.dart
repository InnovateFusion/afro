import '../../domain/entities/shop_info_entity.dart';

class ShopInfoModel extends ShopInfoEntity {
 const ShopInfoModel({required super.id, required super.name, required super.street, required super.subLocality, required super.subAdministrativeArea, required super.postalCode, required super.latitude, required super.longitude, required super.logo, required super.phoneNumber});

  factory ShopInfoModel.fromJson(Map<String, dynamic> json) {
    return ShopInfoModel(
      id: json['id'],
      name: json['name'],
      street: json['street'],
      subLocality: json['subLocality'],
      subAdministrativeArea: json['subAdministrativeArea'],
      postalCode: json['postalCode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      logo: json['logo'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'subLocality': subLocality,
      'subAdministrativeArea': subAdministrativeArea,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'logo': logo,
      'phoneNumber': phoneNumber,
    };
  }
  
}
