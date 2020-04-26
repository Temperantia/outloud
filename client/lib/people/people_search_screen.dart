import 'package:flutter/material.dart';
import 'package:outloud/widgets/people_search.dart';
import 'package:outloud/widgets/view.dart';

class PeopleSearchScreen extends StatefulWidget {
  static const String id = 'PeopleSearch';
  @override
  _PeopleSearchScreenState createState() => _PeopleSearchScreenState();
}

class _PeopleSearchScreenState extends State<PeopleSearchScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return View(title: 'TROUVE DES AMIS', child: PeopleSearch());
  }
}
