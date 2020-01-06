import 'package:flutter/material.dart';

import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/widgets/logo.dart';

class LandingScreen extends StatelessWidget {
  static final String id = 'Landing';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: background,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      logo(context),
                      Column(children: [
                        RaisedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/Register1');
                            },
                            child: Text(
                              'GET STARTED',
                              style: Theme.of(context).textTheme.title,
                            ))
                      ])
                    ]))));
  }
}
