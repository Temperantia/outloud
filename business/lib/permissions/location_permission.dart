import 'package:location_permissions/location_permissions.dart';

class LocationPermissionService {
  final LocationPermissions _locationPermission = LocationPermissions();

  Future<bool> requestLocationPermission() async {
    final PermissionStatus permissionStatus =
        await _locationPermission.requestPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<PermissionStatus> checkLocationPermissionStatus() async {
    return await _locationPermission.checkPermissionStatus();
  }

  Future<ServiceStatus> checkLocationServiceStatus() async {
    return await _locationPermission.checkServiceStatus();
  }

  Future<bool> openAppSettings() async {
    return await LocationPermissions().openAppSettings();
  }
}
