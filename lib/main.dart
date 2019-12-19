import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/routes.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/app.dart';
import 'package:inclusive/screens/appdata.dart';
import 'package:inclusive/screens/loading.dart';
import 'package:inclusive/theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .where('device', isEqualTo: appData.identifier)
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.length > 0) {
                    return AppScreen();
                  }
                  return LandingScreen();
                }
                return LoadingScreen();
              }),
      routes: routes,
      theme: theme,
      title: 'Inclusive',
    );
  }
}
