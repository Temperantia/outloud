import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/widgets/logo.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              logo(context),
              CircularProgressIndicator(backgroundColor: orange),
            ],
          ),
        ),
      ),
    );
  }
}
