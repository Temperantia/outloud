import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

import 'package:inclusive/register/register_3.dart';
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

    Navigator.pushNamed(context, Register3Screen.id,
        arguments: <String, String>{'name': widget.name, 'email': email});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: white),
            centerTitle: true,
            title: const Text(
              'Choose an email',
            )),
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
                          child:
                              Text(_error, style: const TextStyle(color: red)))
                    ]),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                          onPressed: () => submit(),
                          child: const Text('Keep going')))
                ])));
  }
}
