import 'package:business/singletons/permission_location.dart';
import 'package:date_util/date_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

final Geolocator geoLocator = Geolocator();
final PermissionLocation permissionLocation = PermissionLocation();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final DateUtil dateUtility = DateUtil();
