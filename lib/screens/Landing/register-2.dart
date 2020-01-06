import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/screens/Landing/register-3.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:provider/provider.dart';
import 'package:validate/validate.dart';

class Register2Screen extends StatefulWidget {
  Register2Screen(String arguments) : name = arguments;
  static final String id = 'Register2';
  final String name;

  @override
  Register2ScreenState createState() {
    return Register2ScreenState();
  }
}

class Register2ScreenState extends State<Register2Screen> {
  final TextEditingController controller = TextEditingController();
  UserModel userProvider;
  String error = '';

  Future submit() async {
    FocusScope.of(context).unfocus();
    final String email = controller.text.trim();

    try {
      Validate.isEmail(email);
    } catch (e) {
      setState(() => error = 'Email is not valid');
      return;
    }

    final User user = await userProvider.getUserWithEmail(email);
    if (user != null) {
      setState(() => error = 'Email is already used');
      return;
    }
    Navigator.pushNamed(context, Register3Screen.id,
        arguments: {'name': widget.name, 'email': email});
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserModel>(context);

    return Scaffold(
        appBar: AppBar(),
        body: Container(
            decoration: background,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'John•ane@gmail.com',
                      labelText: 'Email',
                    ),
                    controller: controller,
                    onTap: () => error = '',
                  )),
              if (error != '')
                Row(children: [
                  Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(error, style: TextStyle(color: red)))
                ]),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                      onPressed: () => submit(),
                      child: Text('Keep going',
                          style: Theme.of(context).textTheme.caption)))
            ])));
  }
}
