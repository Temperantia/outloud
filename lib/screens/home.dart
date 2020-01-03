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
    final AppDataService appDataService = Provider.of<AppDataService>(context);
    return StreamBuilder(
        stream: appDataService.getUser().asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (snapshot.hasData) {
            appDataService.user = snapshot.data;
            return AppScreen();
          }
          return LandingScreen();
        });
  }
}
