import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/models/groupModel.dart';
import 'package:inclusive/models/messageModel.dart';
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
            create: (_) => locator<AppData>(),
          ),
           ChangeNotifierProvider(
            create: (_) => locator<MessageService>(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
          routes: routes,
          theme: theme,
          title: 'Inclusive',
        ));
  }
}
