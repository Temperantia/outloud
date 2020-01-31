import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inclusive/classes/group.dart';
import 'package:inclusive/models/group.dart';
import 'package:inclusive/services/auth.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider/provider.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  Widget _buildGroup(Group group) {
    return FutureBuilder<List<Placemark>>(
        future: group.location == null
            ? Future<List<Placemark>>(null)
            : Geolocator().placemarkFromCoordinates(
                group.location.latitude, group.location.longitude),
        builder:
            (BuildContext context, AsyncSnapshot<List<Placemark>> location) =>
                Card(
                    color: orange,
                    child: Column(children: <Widget>[
                      _buildUpperRow(group, location.data),
                      Divider(color: black),
                      _buildMiddleRow(group),
                      Divider(color: black),
                      _buildLowerRow(group),
                    ])));
  }

  Row _buildUpperRow(Group group, List<Placemark> location) {
    String info = group.name;
    if (location != null) {
      info += ' • ${location[0].name}';
    }
    return Row(
      children: <Widget>[
        Container(
            width: 100.0,
            child: Image.asset('images/default-user-profile-image-png-7.png',
                fit: BoxFit.fill)),
        Column(children: <Widget>[
          Row(
            children: <Widget>[Text(info)],
          ),
          Row(
            children: const <Widget>[Text('Interests')],
          )
        ]),
      ],
    );
  }

  Widget _buildMiddleRow(Group group) {
    return ExpandablePanel(
        header: const Text('12k members'),
        collapsed: Text(
          group.description,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        expanded: Text(group.description));
  }

  Row _buildLowerRow(Group group) {
    return Row(
      children: const <Widget>[Text('New members today')],
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context);
    final GroupModel groupProvider = Provider.of(context);

    return FutureBuilder<List<Group>>(
        future: groupProvider.getGroups(authService.identifier),
        builder: (BuildContext context, AsyncSnapshot<List<Group>> groups) =>
            !groups.hasData
                ? Loading()
                : ListView.builder(
                    itemCount: groups.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildGroup(groups.data[index])));
  }
}
