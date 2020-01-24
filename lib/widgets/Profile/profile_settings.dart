import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/birthdate_picker.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatelessWidget {
  Future<void> _onSave(User user, BuildContext context) async {
    final UserModel _userProvider = Provider.of<UserModel>(context);
    _userProvider.updateUser(user);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final TextEditingController _nameController = TextEditingController()
      ..text = user.name;
    final TextEditingController _emailController = TextEditingController()
      ..text = user.email;
    DateTime birthDate = user.birthDate;

    return ListView(padding: const EdgeInsets.all(20.0), children: <Widget>[
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Name',
                focusColor: orange,
                border: const OutlineInputBorder()),
            controller: _nameController,
          )),
      Column(children: <Widget>[
        Row(children: const <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('Your birthdate'))
        ]),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: BirthdatePicker(
              initial: birthDate,
              onChange: (DateTime b) => birthDate = b,
            )),
      ]),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Email',
                focusColor: orange,
                border: const OutlineInputBorder()),
            controller: _emailController,
          )),
      Padding(
          padding: const EdgeInsets.all(20.0),
          child: RaisedButton(
              onPressed: () {
                final String name = _nameController.text.trim();
                final String email = _emailController.text.trim();
                user.name = name;
                user.birthDate = birthDate;
                user.email = email;
                return _onSave(user, context);
              },
              child: const Text('Save')))
    ]);
  }
}
