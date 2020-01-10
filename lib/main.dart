import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/locator.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/screens/landing.dart';
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
        providers: <ChangeNotifierProvider<dynamic>>[
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          title: 'Inclusive',
          initialRoute: LandingScreen.id,
          onGenerateRoute: (RouteSettings settings) {
            print(settings.name);
            final Widget Function(dynamic) createRoute = routes[settings.name];
            return MaterialPageRoute<Widget>(
                builder: (BuildContext context) =>
                    createRoute(settings.arguments));
          },
        ));
  }
}
