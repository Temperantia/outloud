import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/button-text.dart';

class ResultsScreen extends StatefulWidget {
  static final String id = '/Results';
  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ButtonText(text: 'ok', isSelected: () => true, onTap: () {
      Navigator.pop(context);
    }));
  }
}