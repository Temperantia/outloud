import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'Profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeStyle _themeStyle;

  Widget _buildAboutBloc(String title, String content) {
    return content == null || content.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: textStyleCardItemTitle),
                    Text(content, style: textStyleCardItemContent(_themeStyle)),
                  ]),
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
      _themeStyle = state.theme;
      return View(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(_themeStyle == ThemeStyle.Orange
                          ? 'images/screenPattern.png'
                          : 'images/screenPatternPurple.png'),
                      fit: BoxFit.cover)),
              child: DefaultTabController(
                length: 2,
                child: Column(children: <Widget>[
                  const SizedBox(height: 20.0),
                  Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(180.0)),
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(180.0),
                          child: user.pics.isEmpty
                              ? Image.asset(
                                  'images/default-user-profile-image-png-7.png',
                                  fit: BoxFit.fill)
                              : CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: user.pics[0],
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          const CircularProgressIndicator(),
                                  errorWidget: (BuildContext context,
                                          String url, Object error) =>
                                      Icon(Icons.error)))),
                  Text('${user.name} • ${user.getAge()}',
                      style: textStyleTitle(state.theme)),
                  Container(
                      child: const TabBar(
                    indicator: BoxDecoration(),
                    unselectedLabelStyle: TextStyle(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: <Widget>[
                      Tab(text: 'INTERESTS'),
                      Tab(text: 'ABOUT'),
                    ],
                  )),
                  Expanded(
                      child: TabBarView(children: <Widget>[
                    SingleChildScrollView(
                        child: Container(
                            color: white,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(children: <Widget>[
                                  for (final Interest interest
                                      in user.interests)
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
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          'https://firebasestorage.googleapis.com/v0/b/incl-9b378.appspot.com/o/images%2Finterests%2F${interest.name}.png?alt=media',
                                                      placeholder: (BuildContext
                                                                  context,
                                                              String url) =>
                                                          const CircularProgressIndicator(),
                                                      errorWidget: (BuildContext
                                                                  context,
                                                              String url,
                                                              Object error) =>
                                                          Icon(Icons.error))),
                                              Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                    Text(interest.name,
                                                        style:
                                                            textStyleListItemTitle),
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
                        child: Container(
                            color: white,
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(children: <Widget>[
                                  _buildAboutBloc('LOCATION', user.home),
                                  _buildAboutBloc('GENDER', user.gender),
                                  _buildAboutBloc('PRONOUN', user.pronoun),
                                  _buildAboutBloc(
                                      'SEXUAL ORIENTATION', user.orientation),
                                  _buildAboutBloc('EDUCATION', user.education),
                                  _buildAboutBloc(
                                      'OCCUPATION', user.profession),
                                ])))),
                  ])),
                ]),
              )));
    });
  }
}
