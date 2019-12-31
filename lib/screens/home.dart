import 'package:flutter/cupertino.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/app.dart';
import 'package:inclusive/screens/loading.dart';
import 'package:inclusive/models/userModel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserModel>(context);
    final appDataProvider = Provider.of<AppData>(context);
    return FutureBuilder(
        future: appDataProvider.completer.future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          return StreamBuilder(
              stream:
                  userProvider.getUser(appDataProvider.identifier).asStream(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen();
                }
                if (snapshot.hasData) {
                  appDataProvider.user = snapshot.data;
                  return AppScreen();
                }
                return LandingScreen();
              });
        });
  }
}
