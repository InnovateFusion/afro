import 'package:equatable/equatable.dart';

class ShopInfoEntity extends Equatable {
  final String id;
  final String name;
  final String street;
  final String subLocality;
  final String subAdministrativeArea;
  final String postalCode;
  final double latitude;
  final double longitude;
  final String logo;
  final String phoneNumber;

  const ShopInfoEntity({
    required this.id,
    required this.name,
    required this.street,
    required this.subLocality,
    required this.subAdministrativeArea,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.logo,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        street,
        subLocality,
        subAdministrativeArea,
        postalCode,
        latitude,
        longitude,
        logo,
        phoneNumber,
      ];
}
