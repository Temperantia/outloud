import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/services/app_data.dart';
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
  AppDataService _appDataService;
  UserModel _userProvider;
  DateTime _selected;

  Future<void> submit() async {
    final User user = User(
      id: _appDataService.identifier,
      name: widget.arguments['name'],
      email: widget.arguments['email'],
      birthDate: _selected,
    );
    await _userProvider.createUser(user);
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.id, (Route<dynamic> route) => false,
        arguments: 0);
  }

  @override
  Widget build(BuildContext context) {
    _appDataService = Provider.of<AppDataService>(context);
    _userProvider = Provider.of<UserModel>(context);
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