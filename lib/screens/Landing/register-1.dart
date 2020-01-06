// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:inclusive/screens/Landing/register-2.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:provider/provider.dart';

class Register1Screen extends StatefulWidget {
  static final String id = '/Register1';
  @override
  Register1ScreenState createState() {
    return Register1ScreenState();
  }
}

class Register1ScreenState extends State<Register1Screen> {
  final TextEditingController controller = TextEditingController();
  UserModel userProvider;
  bool isTakenUsername = false;

  Future submit() async {
    FocusScope.of(context).unfocus();
    final String name = controller.text.trim();
    if (name == '') {
      Navigator.pushNamed(context, Register2Screen.id, arguments: name);
      return;
    }

    User user = await userProvider.getUserWithName(name);
    if (user != null) {
      setState(() => isTakenUsername = true);
      return;
    }
    Navigator.pushNamed(context, Register2Screen.id, arguments: name);
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
                  decoration: InputDecoration(
                    hintText: 'John•ane',
                    labelText: 'Username',
                  ),
                  controller: controller,
                  onTap: () => isTakenUsername = false,
                ),
              ),
              if (isTakenUsername)
                Row(children: [
                  Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Name is taken already',
                          style: TextStyle(color: red)))
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
