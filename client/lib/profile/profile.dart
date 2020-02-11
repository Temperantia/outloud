import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget _buildAboutBloc(String title, String content) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: TextStyle(color: grey, fontWeight: FontWeight.bold)),
              Text(content),
            ],
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<dynamic>) dispatch,
        Widget child) {
      final User user = state.userState.user;
      if (user == null) {
        return Loading();
      }
      return DefaultTabController(
          length: 2,
          child: Stack(children: <Widget>[
            Column(children: <Widget>[
              const SizedBox(height: 20.0),
              Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      color: pink, borderRadius: BorderRadius.circular(180.0)),
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: user.pics.isEmpty
                        ? Image.asset(
                            'images/default-user-profile-image-png-7.png',
                            fit: BoxFit.fill)
                        : Image.network(user.pics[0].toString(),
                            fit: BoxFit.fill),
                  )),
              Text(user.name,
                  style: TextStyle(
                      color: pink,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold)),
              Container(
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(20.0)),
                  margin: const EdgeInsets.all(10.0),
                  child: TabBar(
                    indicator: const BoxDecoration(),
                    unselectedLabelStyle: const TextStyle(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    indicatorColor: pink,
                    tabs: const <Widget>[
                      Tab(text: 'INTERESTS'),
                      Tab(text: 'ABOUT'),
                    ],
                  )),
              Expanded(
                  child: TabBarView(children: <Widget>[
                SingleChildScrollView(
                    child: Card(
                        color: white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(children: <Widget>[
                              for (final Interest interest in user.interests)
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              width: 50.0,
                                              height: 50.0,
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Image.network(
                                                  'https://firebasestorage.googleapis.com/v0/b/incl-9b378.appspot.com/o/images%2Finterests%2F${interest.name}.png?alt=media')),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                Text(interest.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0)),
                                                Text(
                                                  interest.comment,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 10,
                                                )
                                              ])),
                                        ])),
                            ])))),
                SingleChildScrollView(
                    child: Card(
                        color: white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(children: <Widget>[
                              _buildAboutBloc(
                                  'Birthdate',
                                  DateFormat('dd/MM/yyyy')
                                      .format(user.birthDate)),
                              _buildAboutBloc('Education', user.education),
                              _buildAboutBloc('Profession', user.profession),
                              _buildAboutBloc('About me', user.description),
                            ])))),
              ])),
            ]),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                    width: 30.0,
                    height: 30.0,
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                        onTap: () {},
                        child: Image.asset('images/equipo.png', color: pink)))),
          ]));
    });
  }
}
