import 'package:flutter/material.dart';

import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/widgets/logo.dart';

class LandingScreen extends StatelessWidget {
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
              Column(
                children: [
                  /*
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/Login');
                    },
                    child: Text(
                      'LOG ME IN',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  */
                  // const SizedBox(height: 30),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/Register');
                    },
                    child: Text(
                      'SIGN ME IN',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
