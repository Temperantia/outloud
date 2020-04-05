import 'package:flutter/material.dart';

import 'package:outloud/theme.dart';
import 'package:outloud/widgets/background.dart';
import 'package:outloud/widgets/logo.dart';

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
                      const CircularProgressIndicator(backgroundColor: orange),
                    ]))));
  }
}
