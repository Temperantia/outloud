import 'package:flutter/material.dart';

import 'package:inclusive/locator.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/group.dart';
import 'package:inclusive/models/message.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/services/message.dart';

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => locator<UserModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<GroupModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<MessageModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<AppDataService>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<MessageService>(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          title: 'Inclusive',
          initialRoute: HomeScreen.id,
          onGenerateRoute: (RouteSettings settings) {
            print(settings.name);
            final Function createRoute = routes[settings.name];
            return MaterialPageRoute(
                builder: (context) => createRoute(settings.arguments));
          },
        ));
  }
}
