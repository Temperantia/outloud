import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/register/register_2.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';

class Register1Screen extends StatefulWidget {
  static const String id = 'Register1';
  @override
  _Register1ScreenState createState() => _Register1ScreenState();
}

class _Register1ScreenState extends State<Register1Screen> {
  final TextEditingController _controller = TextEditingController();
  UserModel _userProvider;
  bool _isTakenUsername = false;

  Future<void> submit() async {
    FocusScope.of(context).unfocus();
    final String name = _controller.text.trim();
    if (name.isEmpty) {
      Navigator.pushNamed(context, Register2Screen.id, arguments: name);
      return;
    }

    final User user = await _userProvider.getUserWithName(name);
    if (user != null) {
      setState(() => _isTakenUsername = true);
      return;
    }
    Navigator.pushNamed(context, Register2Screen.id, arguments: name);
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context);

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: white),
            centerTitle: true,
            title:
                Text('Pick a name', style: Theme.of(context).textTheme.title)),
        body: Container(
            decoration: background,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                        decoration: const InputDecoration(hintText: 'Riley'),
                        controller: _controller,
                        onTap: () => _isTakenUsername = false),
                  ),
                  if (_isTakenUsername)
                    Row(children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('Name is taken already',
                              style: TextStyle(color: red)))
                    ]),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                          onPressed: () => submit(),
                          child: const Text('Keep going')))
                ])));
  }
}
