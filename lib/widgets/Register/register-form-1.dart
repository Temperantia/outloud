// Define a custom Form widget.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/screens/appdata.dart';
class RegisterForm1 extends StatefulWidget {
  final Function previous;
  final Function next;

  const RegisterForm1({Key key, this.previous, this.next}) : super(key: key);

  @override
  RegisterForm1State createState() {
    return RegisterForm1State();
  }
}

class RegisterForm1State extends State<RegisterForm1> {
  final _formKey = GlobalKey<FormState>();
  bool isTakenUsername;

  @override
  Widget build(BuildContext context) {
    isTakenUsername = false;
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
                  decoration: InputDecoration(
                    hintText: 'John•ane',
                    labelText: 'Username',
                  ),
                  validator: (String value) {
                    if (isTakenUsername) {
                      return 'Name is already taken';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    appData.user.name = value;
                  })),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                _formKey.currentState.save();
                Firestore.instance
                    .collection('users')
                    .where('name', isEqualTo: appData.user.name)
                    .getDocuments()
                    .then((users) {
                  if (users.documents.length > 0) {
                    setState(() {
                      isTakenUsername = true;
                    });
                  }
                  if (_formKey.currentState.validate()) {
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
