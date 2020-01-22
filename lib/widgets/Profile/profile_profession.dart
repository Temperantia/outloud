import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class ProfileProfession extends StatefulWidget {
  const ProfileProfession(this.profession, {Key key}) : super(key: key);

  final String profession;

  @override
  ProfileProfessionState createState() => ProfileProfessionState();
}

class ProfileProfessionState extends State<ProfileProfession> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.profession;
  }

  String onSave() {
    return _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Profession',
          focusColor: orange,
          border: const OutlineInputBorder()),
      controller: _controller,
    );
  }
}
