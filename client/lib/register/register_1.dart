import 'package:flutter/material.dart';

import 'package:inclusive/register/register_2.dart';
import 'package:inclusive/widgets/view.dart';

class Register1Screen extends StatefulWidget {
  static const String id = 'Register1';
  @override
  _Register1ScreenState createState() => _Register1ScreenState();
}

class _Register1ScreenState extends State<Register1Screen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> submit() async {
    FocusScope.of(context).unfocus();
    final String name = _controller.text.trim();
    if (name.isEmpty) {
      Navigator.pushNamed(context, Register2Screen.id, arguments: name);
      return;
    }

    Navigator.pushNamed(context, Register2Screen.id, arguments: name);
  }

  @override
  Widget build(BuildContext context) {
    return View(
        title: 'Pick a name',
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: const InputDecoration(hintText: 'Riley'),
                    controller: _controller,
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                      onPressed: () => submit(),
                      child: const Text('Keep going')))
            ]));
  }
}
