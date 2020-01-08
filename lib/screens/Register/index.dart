import 'package:flutter/material.dart';
import 'package:inclusive/screens/Register/register-1.dart';

import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/widgets/logo.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'Register';
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
                      Column(children: <Widget>[
                        RaisedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Register1Screen.id);
                            },
                            child: Text(
                              'GET STARTED',
                              style: Theme.of(context).textTheme.title,
                            ))
                      ])
                    ]))));
  }
}
