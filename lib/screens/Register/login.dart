import 'package:flutter/material.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/models/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  UserModel _userProvider;

  Future<void> submit() async {}

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context);
    final AppDataService appDataService = Provider.of(context);

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
                  OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: () => appDataService.handleSignIn(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Image(
                              image: AssetImage('images/google_logo.png'),
                              height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ])));
  }
}
