import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({this.connected, this.onLoginGoogle});
  final bool connected;
  final VoidCallback onLoginGoogle;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  Text(connected.toString()),
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
                        //authService.signInEmail(
                        //    _controllerEmail.text, _controllerPassword.text);
                        //Navigator.of(context).pushNamed(LoginScreen.id);
                      },
                      child: Text('LOGIN',
                          style: Theme.of(context).textTheme.title)),
                  const SizedBox(height: 50.0),
                  Container(
                      width: 270.0,
                      child: GoogleSignInButton(onPressed: onLoginGoogle)),
                  Container(
                      width: 270.0,
                      child: FacebookSignInButton(
                          //onPressed: () => authService.signInFacebook(),
                          ))
                ])));
  }
}
