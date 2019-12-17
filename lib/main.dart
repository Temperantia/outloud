import 'package:flutter/material.dart';

import 'package:inclusive/routes.dart';
import 'package:inclusive/screens/app.dart';
import 'package:inclusive/theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppScreen(),
      routes: routes,
      theme: theme,
      title: 'Inclusive',
    );
  }
}