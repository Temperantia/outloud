import 'package:flutter/cupertino.dart';
import 'package:inclusive/screens/appdata.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/app.dart';
import 'package:inclusive/screens/loading.dart';
import 'package:inclusive/models/userModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserModel>(context);
    return StreamBuilder(
        stream: userProvider.getUser(appData.identifier).asStream(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (snapshot.hasData) {
            return AppScreen();
          }
          return LandingScreen();
        });
  }
}
