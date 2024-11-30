import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationHandler {
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled. Please enable the services
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<Address?> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];
      return Address(
        street: place.street.toString(),
        subLocality: place.subLocality.toString(),
        subAdministrativeArea: place.subAdministrativeArea.toString(),
        postalCode: place.postalCode.toString(),
      );
    } catch (e) {
      return null;
    }
  }
} 

class Address {
  final String street;
  final String subLocality;
  final String subAdministrativeArea;
  final String postalCode;

  Address({
    required this.street,
    required this.subLocality,
    required this.subAdministrativeArea,
    required this.postalCode,
  });
}