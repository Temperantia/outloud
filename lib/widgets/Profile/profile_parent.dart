import 'package:flutter/material.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/screens/Profile/profile_information.dart';
import 'package:inclusive/theme.dart';

class ProfileParent extends StatelessWidget {
  const ProfileParent(this.user);

  final User user;

  void _onClickView(BuildContext context, String view, {User user}) {
    Navigator.pushNamed(context, view, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
        Widget>[
      Column(children: <Widget>[
        Container(
            width: 200.0,
            height: 200.0,
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(180.0),
              child: user.pics.isEmpty
                  ? Image.asset('images/default-user-profile-image-png-7.png',
                      fit: BoxFit.fill)
                  : Image.network(user.pics[0].toString(), fit: BoxFit.fill),
            )),
        Text('${user.name} • ${user.getAge().toString()} • ${user.home}',
            style: const TextStyle(fontSize: 30.0))
      ]),
      Column(
        children: <Widget>[
          GestureDetector(
              //onTap: () => _onClickView(),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(color: yellow),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.tune),
                        const Text('Settings',
                            style: TextStyle(fontSize: 20.0)),
                      ]))),
          GestureDetector(
              onTap: () => _onClickView(context, ProfileInformationScreen.id),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(color: orange),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.brush),
                        const Text('Personal Information',
                            style: TextStyle(fontSize: 20.0)),
                      ]))),
          GestureDetector(
              onTap: () => _onClickView(context, ProfileScreen.id, user: user),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(color: blueLight),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.remove_red_eye),
                        const Text('See how you appear',
                            style: TextStyle(fontSize: 20.0)),
                      ])))
        ],
      )
    ]);
  }
}
