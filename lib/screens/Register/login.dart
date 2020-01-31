import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:inclusive/services/auth.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> submit() async {}

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context);

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: white),
            centerTitle: true,
            title: Text('Login', style: Theme.of(context).textTheme.title)),
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
                      )),
                  GoogleSignInButton(
                      onPressed: () => authService.signInGoogle()),
                  FacebookSignInButton(
                    onPressed: () => authService.signInFacebook(),
                  )
                ])));
  }
}
