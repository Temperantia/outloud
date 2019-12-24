import 'package:flutter/material.dart';

import 'package:inclusive/widgets/Register/register-form-1.dart';
import 'package:inclusive/widgets/Register/register-form-2.dart';
import 'package:inclusive/widgets/Register/register-form-3.dart';
import 'package:inclusive/widgets/background.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  PageController controller = PageController();

  quit() {
    Navigator.of(context).pushReplacementNamed('/Landing');
  }

  login() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }

  nextStep() {
    controller.nextPage(
        duration: Duration(milliseconds: 500), curve: Cubic(1, 1, 1, 1));
  }

  previousStep() {
    controller.previousPage(
        duration: Duration(milliseconds: 500), curve: Cubic(1, 1, 1, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: background,
        child: PageView(
          pageSnapping: false,
          controller: controller,
          children: [
            RegisterForm1(
              previous: () => quit(),
              next: () => nextStep(),
            ),
            RegisterForm2(
              previous: () => previousStep(),
              next: () => nextStep(),
            ),
            RegisterForm3(
              previous: () => previousStep(),
              next: () => login(),
            ),
          ],
        ),
      ),
    );
  }
}
