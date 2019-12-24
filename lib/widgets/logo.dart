import 'package:flutter/material.dart';

final logo = (context) => Column(
  children: [
    Image.asset(
      'images/logo.png',
      height: MediaQuery.of(context).size.height * 0.3,
    ),
    Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        'Lets\'s include today',
        style: Theme.of(context).textTheme.subhead,
      ),
    )
  ],
);
