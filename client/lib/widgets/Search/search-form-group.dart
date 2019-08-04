// Define a custom Form widget.
import 'package:flutter/material.dart';

class SearchFormGroup extends StatefulWidget {
  @override
  SearchFormGroupState createState() {
    return SearchFormGroupState();
  }
}

class SearchFormGroupState extends State<SearchFormGroup> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text(
              'Submit',
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }
}
