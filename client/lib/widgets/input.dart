import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class TextInput extends StatelessWidget {
  final String name;
  final String hint;

  TextInput({Key key, @required this.name, @required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Text(
                  this.name,
                  style: TextStyle(
                    color: white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: this.hint,
                    filled: true,
                    fillColor: white,
                    hintStyle: TextStyle(color: orangeLight),
                    focusColor: orange,
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)))),
                style: TextStyle(color: orange),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter some text';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
