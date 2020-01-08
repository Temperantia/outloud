import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/screens/Search/results.dart';
import 'package:inclusive/widgets/Search/search_event.dart';
import 'package:inclusive/widgets/Search/search_group.dart';
import 'package:inclusive/widgets/Search/search_solo.dart';
import 'package:inclusive/theme.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  UserModel userProvider;
  String type = 'solo';
  Widget resultWidget;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserModel>(context);
    return Column(children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <GestureDetector>[
                GestureDetector(
                    onTap: () => setState(() => type = 'solo'),
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: type == 'solo' ? orange : blue,
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(20),
                        child: Icon(Icons.person, color: white))),
                GestureDetector(
                    onTap: () => setState(() => type = 'group'),
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: type == 'group' ? orange : blue,
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(15),
                        child: Icon(Icons.group, color: white))),
                GestureDetector(
                    onTap: () => setState(() => type = 'event'),
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: type == 'event' ? orange : blue,
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(15),
                        child: Icon(Icons.event, color: white)))
              ])),
      Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: type == 'solo'
              ? SearchSolo(onSearch: buildSoloResults)
              : type == 'group' ? SearchGroup() : SearchEvent())
    ]);
  }

  Future<void> buildSoloResults(
      List<String> interests, int ageStart, int ageEnd, double distance) async {
    final List<User> users = await userProvider.getUsers(
        interests: interests,
        ageStart: ageStart,
        ageEnd: ageEnd,
        distance: distance);

    Navigator.pushNamed(context, ResultsScreen.id, arguments: users);
  }
}
