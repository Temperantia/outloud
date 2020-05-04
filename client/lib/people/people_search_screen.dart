import 'package:flutter/material.dart'
    show BuildContext, State, StatefulWidget, TickerProviderStateMixin, Widget;
import 'package:outloud/widgets/people_search.dart' show PeopleSearch;
import 'package:outloud/widgets/view.dart' show View;

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
