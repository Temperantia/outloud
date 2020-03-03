import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/interest.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.user);
  static const String id = 'Profile';
  final User user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeStyle _themeStyle;

  Widget _buildTabBarView() {
    return Expanded(
        child: TabBarView(children: <Widget>[
      SingleChildScrollView(
          child: Container(
              color: white,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(children: <Widget>[
                    for (final Interest interest in widget.user.interests)
                      _buildInterest(interest)
                  ])))),
      SingleChildScrollView(
          child: Container(
              color: white,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    _buildAboutBloc('LOCATION', widget.user.home),
                    _buildAboutBloc('GENDER', widget.user.gender),
                    _buildAboutBloc('PRONOUN', widget.user.pronoun),
                    _buildAboutBloc(
                        'SEXUAL ORIENTATION', widget.user.orientation),
                    _buildAboutBloc('EDUCATION', widget.user.education),
                    _buildAboutBloc('OCCUPATION', widget.user.profession),
                  ])))),
    ]));
  }

  Widget _buildInterest(Interest interest) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CircularImage(
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/incl-9b378.appspot.com/o/images%2Finterests%2F${interest.name}.png?alt=media',
                      imageRadius: 50.0)),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(interest.name, style: textStyleListItemTitle),
                    Text(
                      interest.comment,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                    ),
                  ])),
            ]));
  }

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
                    CircularImage(
                      imageUrl:
                          widget.user.pics.isEmpty ? null : widget.user.pics[0],
                      imageRadius: 150.0,
                    ),
                    Text('${widget.user.name} • ${widget.user.getAge()}',
                        style: textStyleTitle(state.theme)),
                    const TabBar(
                        indicator: BoxDecoration(),
                        unselectedLabelStyle: TextStyle(),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        tabs: <Widget>[
                          Tab(text: 'INTERESTS'),
                          Tab(text: 'ABOUT'),
                        ]),
                    _buildTabBarView(),
                  ]))));
    });
  }
}
