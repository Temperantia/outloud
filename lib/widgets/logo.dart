import 'package:flutter/material.dart';

final Widget Function(BuildContext) logo = (BuildContext context) => Column(
      children: <Widget>[
        Image.asset(
          'images/logo.png',
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Let\'s include today',
            style: Theme.of(context).textTheme.subhead,
          ),
        )
      ],
    );
