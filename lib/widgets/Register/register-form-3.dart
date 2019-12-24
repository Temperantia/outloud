import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:inclusive/screens/appdata.dart';
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserModel>(context);
    selected = DateTime(now.year - 18, now.month, now.day);
    appData.user.birthDate = selected;
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
      DatePickerWidget(
        maxDateTime: DateTime(now.year - 13, now.month, now.day),
        minDateTime: DateTime(now.year - 99, now.month, now.day),
        initialDateTime: selected,
        pickerTheme: DateTimePickerTheme(title: Text('Birthdate')),
        onChange: (dateTime, _) => appData.user.birthDate = dateTime,
      ),
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
            userProvider.updateUser(User.fromMap({
              'name': appData.user.name,
              'email': appData.user.email,
              'birthDate': appData.user.birthDate,
              'device': appData.identifier,
            }, appData.identifier), appData.identifier)
           .then((_) {
              widget.next();
            }).catchError((error) => print(error));
          },
        ),
      ),
    ]);
  }
}
