import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:inclusive/appdata.dart';
import 'package:inclusive/widgets/Profile/birthdate-picker.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/userModel.dart';

class RegisterForm3 extends StatefulWidget {
  final Function previous;
  final Function next;

  const RegisterForm3({Key key, this.previous, this.next}) : super(key: key);

  @override
  RegisterForm3State createState() {
    return RegisterForm3State();
  }
}

class RegisterForm3State extends State<RegisterForm3> {
  DateTime now = DateTime.now();
  DateTime selected;
  var appDataProvider;

  @override
  Widget build(BuildContext context) {
    final appDataProvider = Provider.of<AppData>(context);
    final userProvider = Provider.of<UserModel>(context);
    selected = DateTime(now.year - 18, now.month, now.day);
    appDataProvider.user.birthDate = selected;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: () {
            widget.previous();
          },
          child: const Text('Go back'),
        ),
      ),
      BirthdatePicker(
          initial: selected,
          onChange: (dateTime) => appDataProvider.user.birthDate = dateTime,
          theme: DateTimePickerTheme(title: Text('Birthdate'))),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          child: const Text('Get me in already'),
          onPressed: () {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: const Text('Getting you in ...'),
              ),
            );
            userProvider
                .createUser(appDataProvider.user, appDataProvider.identifier)
                .then((_) {
              appDataProvider.user.id = appDataProvider.identifier;
              widget.next();
            }).catchError((error) => print(error));
          },
        ),
      ),
    ]);
  }
}
