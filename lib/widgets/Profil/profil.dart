import 'package:flutter/material.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/screens/appdata.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/CRUDmodel.dart';

import '../../theme.dart';

class Profil extends StatelessWidget {
  User user;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<CRUDModel>(context);
    return FutureBuilder(
        future: userProvider.getUser(appData.identifier),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
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
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 32,
                        color: orange,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          '25 years old',
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
                          'San Francisco, California, USA',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            color: orange,
                          ),
                        )),
                  ],
                ),
                Divider(
                  color: Colors.red,
                  height: 10,
                  indent: 100,
                  endIndent: 100,
                  thickness: 1,
                ),
                ListTile(
                  dense: true,
                  title: Text('Interests',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: orange,
                      )),
                  subtitle: Text('Gay community, Soccer',
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
                Divider(
                  color: Colors.red,
                  height: 10,
                  indent: 100,
                  endIndent: 100,
                  thickness: 1,
                ),
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
                  subtitle: Text(
                      'Hi my name\'s Justin. This just my description\nI\'m dedicating every day to you Domestic life was never quite my style. When you smile, you knock me out, I fall apart. And I thought I was so smart',
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
          } else {
            return Container();
          }
        });
  }
}
