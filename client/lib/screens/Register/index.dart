import 'package:flutter/material.dart';
import 'package:inclusive/widgets/Register/register-form-1.dart';
import 'package:inclusive/widgets/background.dart';

class Register1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RegisterForm1(),
            ],
          ),
        ),
      ),
    );
  }
}
