import 'package:location_permissions/location_permissions.dart';

class PermissionLocation {
  factory PermissionLocation() {
    return _singletonPermissionLocation;
  }

  PermissionLocation._internal() {
    _locationPermission = LocationPermissions();
  }

  LocationPermissions _locationPermission;

  static final PermissionLocation _singletonPermissionLocation =
      PermissionLocation._internal();

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
