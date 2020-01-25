import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validate/validate.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/screens/Register/register_3.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';

class Register2Screen extends StatefulWidget {
  const Register2Screen(this.name);
  final String name;
  static const String id = 'Register2';

  @override
  _Register2ScreenState createState() => _Register2ScreenState();
}

class _Register2ScreenState extends State<Register2Screen> {
  final TextEditingController _controller = TextEditingController();
  UserModel _userProvider;
  String _error = '';

  Future<void> submit() async {
    FocusScope.of(context).unfocus();
    final String email = _controller.text.trim();

    try {
      Validate.isEmail(email);
    } catch (e) {
      setState(() => _error = 'Email is not valid');
      return;
    }

    final User user = await _userProvider.getUserWithEmail(email);
    if (user != null) {
      setState(() => _error = 'Email is already used');
      return;
    }
    Navigator.pushNamed(context, Register3Screen.id,
        arguments: <String, String>{'name': widget.name, 'email': email});
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserModel>(context);

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: white),
            centerTitle: true,
            title: Text('Choose an email',
                style: Theme.of(context).textTheme.title)),
        body: Container(
            decoration: background,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                          decoration: const InputDecoration(
                              hintText: 'riley@gmail.com'),
                          controller: _controller,
                          onTap: () => _error = '')),
                  if (_error.isNotEmpty)
                    Row(children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(_error, style: TextStyle(color: red)))
                    ]),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                          onPressed: () => submit(),
                          child: const Text('Keep going')))
                ])));
  }
}
