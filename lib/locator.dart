import 'package:get_it/get_it.dart';
import 'package:inclusive/appdata.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/models/groupModel.dart';
import 'package:inclusive/models/messageModel.dart';

import './services/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api('users'), instanceName: 'users');
  locator.registerLazySingleton(() => Api('groups'), instanceName: 'groups');
  locator.registerLazySingleton(() => Api('messages'), instanceName: 'messages');
  locator.registerLazySingleton(() => AppData());
  locator.registerLazySingleton(() => UserModel());
  locator.registerLazySingleton(() => GroupModel());
  locator.registerLazySingleton(() => MessageModel());
}