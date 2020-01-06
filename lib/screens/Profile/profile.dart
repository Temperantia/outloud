import 'package:flutter/material.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/theme.dart';

class Profile extends StatelessWidget {
  final User user;
  Profile(this.user);

  Divider divider() {
    return Divider(
      color: Colors.red,
      height: 10,
      indent: 100,
      endIndent: 100,
      thickness: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: orange,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  user.getAge().toString() + ' years old',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: orange,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.location == null ? '' : user.location,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: orange,
                  ),
                )),
          ],
        ),
        divider(),
        ListTile(
          dense: true,
          title: Text('Interests',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: orange,
              )),
          subtitle: Text(user.interests.join(', '),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: orangeLight,
              )),
          leading: Icon(
            Icons.category,
            color: blueLight,
            size: 40,
          ),
        ),
        divider(),
        ListTile(
          dense: true,
          title: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('About me',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: orange,
                  ))),
          subtitle: Text(user.description,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: orangeLight,
              )),
          leading: Icon(
            Icons.description,
            color: blueLight,
            size: 40,
          ),
        )
      ],
    ));
  }
}
