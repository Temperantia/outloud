import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class ProfileDescription extends StatefulWidget {
  const ProfileDescription(this.description, {Key key}) : super(key: key);

  final String description;

  @override
  ProfileDescriptionState createState() => ProfileDescriptionState();
}

class ProfileDescriptionState extends State<ProfileDescription> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.description;
  }

  String onSave() {
    return _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          labelText: 'About me',
          focusColor: orange,
          border: const OutlineInputBorder()),
      controller: _controller,
    );
  }
}
