import 'package:get_it/get_it.dart';

import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/group.dart';
import 'package:inclusive/models/message.dart';
import 'package:inclusive/services/api.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/services/search.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api('users'), instanceName: 'users');
  locator.registerLazySingleton(() => Api('groups'), instanceName: 'groups');
  locator.registerLazySingleton(() => Api('messages'),
      instanceName: 'messages');
  locator.registerLazySingleton(() => AppDataService());
  locator.registerLazySingleton(() => MessageService());
  locator.registerLazySingleton(() => SearchService());
  locator.registerLazySingleton(() => UserModel());
  locator.registerLazySingleton(() => GroupModel());
  locator.registerLazySingleton(() => MessageModel());
}
