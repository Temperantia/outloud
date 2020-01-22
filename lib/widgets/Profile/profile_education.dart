import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class ProfileEducation extends StatefulWidget {
  const ProfileEducation(this.education, {Key key}) : super(key: key);

  final String education;

  @override
  ProfileEducationState createState() => ProfileEducationState();
}

class ProfileEducationState extends State<ProfileEducation> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.education;
  }

  String onSave() {
    return _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Education',
          focusColor: orange,
          border: const OutlineInputBorder()),
      controller: _controller,
    );
  }
}
