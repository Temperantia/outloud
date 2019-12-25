import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/appdata.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/userModel.dart';

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
            create: (_) => locator<AppData>(),
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
