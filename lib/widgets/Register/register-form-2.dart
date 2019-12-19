// Define a custom Form widget.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/screens/appdata.dart';
import 'package:validate/validate.dart';

class RegisterForm2 extends StatefulWidget {
  final Function previous;
  final Function next;

  const RegisterForm2({Key key, this.previous, this.next}) : super(key: key);

  @override
  RegisterForm2State createState() {
    return RegisterForm2State();
  }
}

class RegisterForm2State extends State<RegisterForm2> {
  final _formKey = GlobalKey<FormState>();
  bool isTakenEmail;

  @override
  Widget build(BuildContext context) {
    isTakenEmail = false;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                widget.previous();
              },
              child: const Text('Go back'),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'John•ane@gmail.com',
                    labelText: 'Email',
                  ),
                  validator: (String value) {
                    try {
                      Validate.isEmail(value);
                    } catch (e) {
                      return 'Email is not valid';
                    }
                    if (isTakenEmail) {
                      return 'Email is already used';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    appData.user.email = value;
                  })),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                _formKey.currentState.save();
                Firestore.instance
                    .collection('users')
                    .where('email', isEqualTo: appData.user.email)
                    .snapshots()
                    .listen((users) {
                  if (users.documents.length > 0) {
                    setState(() {
                      isTakenEmail = true;
                    });
                  }
                  if (_formKey.currentState.validate()) {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    widget.next();
                  }
                });
              },
              child: const Text('Keep going'),
            ),
          ),
        ],
      ),
    );
  }
}
