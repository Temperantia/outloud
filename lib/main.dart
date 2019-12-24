import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';

import 'package:inclusive/routes.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/app.dart';
import 'package:inclusive/screens/appdata.dart';
import 'package:inclusive/screens/loading.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/CRUDmodel.dart';

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  Widget buildHome(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data != null) {
        return AppScreen();
      }
      return LandingScreen();
    }
    return LoadingScreen();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<CRUDModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // loads device id
      home: FutureBuilder(
          future: appData.completer.future,
          // provides models
          builder: (_, snapshot) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => locator<CRUDModel>(),
                    ),
                  ],
                  child: StreamBuilder(
                      stream:
                          userProvider.getUser(appData.identifier).asStream(),
                      builder: (_, snapshot) => buildHome(snapshot)))),
      routes: routes,
      theme: theme,
      title: 'Inclusive',
    );
  }
}
