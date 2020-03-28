import 'package:location_permissions/location_permissions.dart';

class PermissionLocation {
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
    return _locationPermission.checkPermissionStatus();
  }

  Future<ServiceStatus> checkLocationServiceStatus() async {
    return _locationPermission.checkServiceStatus();
  }

  Future<bool> openAppSettings() async {
    return _locationPermission.openAppSettings();
  }
}
