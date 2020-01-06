import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/theme.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatefulWidget {
  ResultsScreen(arguments) : users = arguments;
  final List<User> users;
  static final String id = '/Results';
  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultsScreen> {
  AppDataService appDataService;
  Widget buildUser(User user) {
    return Card(
        color: orange,
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user.name, style: Theme.of(context).textTheme.title),
                  Container(
                      child: Row(children: [
                    Text('5'),
                    Icon(Icons.category),
                    Text('in common')
                  ])),
                  ButtonBar(children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    )
                  ])
                ])));
  }

  osef() async {
    var permission = await appDataService.getLocationPermissions();
    if (permission == PermissionStatus.granted) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    appDataService = Provider.of<AppDataService>(context);
    osef();
    return Scaffold(
        appBar: AppBar(),
        body: widget.users.isEmpty
            ? Container()
            : ListView.builder(
                itemBuilder: (context, index) => buildUser(widget.users[index]),
                itemCount: widget.users.length));
  }
}
