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
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> submit() async {}

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        decoration: const InputDecoration(hintText: 'Email'),
                        controller: _controllerEmail,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        controller: _controllerPassword,
                      )),
                  RaisedButton(
                      onPressed: () {
                        authService.signInEmail(
                            _controllerEmail.text, _controllerPassword.text);
                        //Navigator.of(context).pushNamed(LoginScreen.id);
                      },
                      child: Text('LOGIN',
                          style: Theme.of(context).textTheme.title)),
                  const SizedBox(height: 50.0),
                  Container(
                      width: 270.0,
                      child: GoogleSignInButton(
                          onPressed: () => authService.signInGoogle())),
                  Container(
                      width: 270.0,
                      child: FacebookSignInButton(
                        onPressed: () => authService.signInFacebook(),
                      ))
                ])));
  }
}
