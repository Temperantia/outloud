import 'package:business/singletons/permission_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

final Geolocator geoLocator = Geolocator();
final PermissionLocation permissionLocation = PermissionLocation();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
