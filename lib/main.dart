import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/home.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/locator.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/group.dart';
import 'package:inclusive/models/message.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <ChangeNotifierProvider<ChangeNotifier>>[
          ChangeNotifierProvider<UserModel>(
              create: (_) => locator<UserModel>()),
          ChangeNotifierProvider<GroupModel>(
              create: (_) => locator<GroupModel>()),
          ChangeNotifierProvider<MessageModel>(
              create: (_) => locator<MessageModel>()),
          ChangeNotifierProvider<AppDataService>(
              create: (_) => locator<AppDataService>()),
          ChangeNotifierProvider<MessageService>(
              create: (_) => locator<MessageService>()),
        ],
        child: Consumer2<AppDataService, MessageService>(builder:
            (BuildContext context, AppDataService appDataService,
                MessageService messageService, Widget w) {
          return MultiProvider(
              providers: <SingleChildCloneableWidget>[
                FutureProvider<PermissionStatus>.value(
                    value: appDataService.getLocationPermissions()),
                FutureProvider<ConversationList>.value(
                    value: messageService.getConversationList()),
                StreamProvider<User>.value(value: appDataService.getUser())
              ],
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  title: 'Inclusive',
                  initialRoute: HomeScreen.id,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute<Widget>(
                        builder: (BuildContext context) {
                      return routes[settings.name](settings.arguments);
                    });
                  }));
        }));
  }
}
