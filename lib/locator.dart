import 'package:get_it/get_it.dart';
import 'package:inclusive/appdata.dart';
import 'package:inclusive/models/userModel.dart';

import './services/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api('users'));
  locator.registerLazySingleton(() => AppData());
  locator.registerLazySingleton(() => UserModel());
}