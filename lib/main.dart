import 'package:flutter/material.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/theme.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingScreen(),
      routes: routes,
      title: 'Inclusive',
      theme: theme,
    );
  }
}