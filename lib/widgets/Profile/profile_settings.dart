import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/theme.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final TextEditingController _nameController = TextEditingController()
      ..text = user.name;
    final TextEditingController _emailController = TextEditingController()
      ..text = user.email;
    return ListView(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Name',
                focusColor: orange,
                border: const OutlineInputBorder()),
            controller: _nameController,
          )),
      Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Email',
                focusColor: orange,
                border: const OutlineInputBorder()),
            controller: _emailController,
          )),
    ]);
  }
}
