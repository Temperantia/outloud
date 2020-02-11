import 'package:business/models/user.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';
import 'package:business/classes/user.dart';
import 'package:inclusive/home.dart';
import 'package:inclusive/widgets/birthdate_picker.dart';
import 'package:inclusive/widgets/background.dart';

class Register3Screen extends StatefulWidget {
  const Register3Screen(this.arguments);
  final Map<String, String> arguments;
  static const String id = 'Register3';

  @override
  _Register3ScreenState createState() => _Register3ScreenState();
}

class _Register3ScreenState extends State<Register3Screen> {
  DateTime _selected;

  Future<void> submit() async {
    final User user = User(
      name: widget.arguments['name'],
      email: widget.arguments['email'],
      birthDate: _selected,
    );
    await createUser(user);
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.id, (Route<dynamic> route) => false,
        arguments: 0);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    _selected = DateTime(now.year - 18, now.month, now.day);

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: white),
            centerTitle: true,
            title: Text('Select your birthdate',
                style: Theme.of(context).textTheme.title)),
        body: Container(
            decoration: background,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BirthdatePicker(
                    initial: _selected,
                    onChange: (DateTime dateTime) => _selected = dateTime,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                          child: const Text('Get me in already'),
                          onPressed: () => submit()))
                ])));
  }
}
