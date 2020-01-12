import 'package:flutter/material.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/widgets/view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({this.user});
  final User user;
  static const String id = 'Profile';

  @override
  Widget build(BuildContext context) {
    return View(title: user.name, child: Profile(user));
  }
}
