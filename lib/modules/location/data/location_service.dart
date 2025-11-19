import 'package:geolocator/geolocator.dart' hide ServiceStatus;
import '../models/place_details.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {

  static Future<PlaceDetails?> getCurrentLocation() async {
    print('dASDASDAS');
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) return null;

    final pos = await Geolocator.getCurrentPosition();

    return PlaceDetails(
      name: "Current Location",
      lat: pos.latitude,
      lng: pos.longitude,
    );
  }


  static Future<bool> askLocationPermission() async {
    // Check permission status
    var status = await Permission.location.status;

    // Already granted
    if (status.isGranted) {
      // Check if GPS is ON
      final serviceStatus = await Permission.location.serviceStatus;
      return serviceStatus == ServiceStatus.enabled;
    }

    // If denied, request again
    if (status.isDenied) {
      status = await Permission.location.request();

      if (status.isGranted) {
        // After granted → check GPS
        final serviceStatus = await Permission.location.serviceStatus;
        return serviceStatus == ServiceStatus.enabled;
      }

      return false;
    }

    // If permanently denied → open settings
    if (status.isPermanentlyDenied) {
      openAppSettings(); // user must enable manually
      return false;
    }

    return false;
  }

}
