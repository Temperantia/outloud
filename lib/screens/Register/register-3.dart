import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/widgets/birthdate-picker.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/user.dart';

class Register3Screen extends StatefulWidget {
  Register3Screen(this.arguments);
  final Map<String, String> arguments;
  static final String id = 'Register3';

  @override
  Register3ScreenState createState() {
    return Register3ScreenState();
  }
}

class Register3ScreenState extends State<Register3Screen> {
  final DateTime now = DateTime.now();
  AppDataService appDataService;
  UserModel userProvider;
  DateTime selected;

  Future submit() async {
    final User user = User(
      id: appDataService.identifier,
      name: widget.arguments['name'],
      email: widget.arguments['email'],
      birthDate: selected,
    );
    await userProvider.createUser(user);
    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    appDataService = Provider.of<AppDataService>(context);
    userProvider = Provider.of<UserModel>(context);
    selected = DateTime(now.year - 18, now.month, now.day);

    return Scaffold(
        appBar: AppBar(),
        body: Container(
            decoration: background,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              BirthdatePicker(
                  initial: selected,
                  onChange: (dateTime) => selected = dateTime,
                  theme: DateTimePickerTheme(title: Text('Birthdate'))),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                      child: Text('Get me in already',
                          style: Theme.of(context).textTheme.caption),
                      onPressed: () => submit()))
            ])));
  }
}
