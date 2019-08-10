// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/input.dart';

class RegisterForm1 extends StatefulWidget {
  @override
  RegisterForm1State createState() {
    return RegisterForm1State();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class RegisterForm1State extends State<RegisterForm1> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<RegisterForm1State>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              child: TextInput(name: 'Username', hint: 'J•hn•an•nie')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Processing Data'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
