import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/actions/app_update_theme_action.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/profile/profile_screen.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class View extends StatefulWidget {
  const View(
      {@required this.child,
      this.showAppBar = true,
      this.showNavBar = true,
      this.title = ''});

  final Widget child;
  final bool showAppBar;
  final bool showNavBar;
  final String title;
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  bool _isSwitched = false;
  bool _showUserSettings = false;

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) =>
            <dynamic>[state.homePageIndex, state.userState.user],
        builder: (BuildContext context,
            Store<AppState> store,
            AppState state,
            void Function(ReduxAction<dynamic>) dispatch,
            dynamic model,
            Widget w) {
          final User user = state.userState.user;
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: widget.showAppBar
                  ? AppBar(
                      centerTitle: true,
                      title: user == null
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () => setState(
                                  () => _showUserSettings = !_showUserSettings),
                              child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(180.0),
                                      child: user.pics == null || user.pics.isEmpty
                                          ? Image.asset(
                                              'images/default-user-profile-image-png-7.png',
                                              fit: BoxFit.fill)
                                          : CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: user.pics[0],
                                              placeholder: (BuildContext context, String url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget: (BuildContext context,
                                                      String url,
                                                      Object error) =>
                                                  Icon(Icons.error))))),
                      leading: Navigator.canPop(context)
                          ? GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.keyboard_arrow_left, color: white))
                          : null,
                      actions: <Widget>[
                          Switch(
                            value: _isSwitched,
                            onChanged: (bool value) {
                              setState(() {
                                dispatch(AppUpdateThemeAction(_isSwitched
                                    ? ThemeStyle.Orange
                                    : ThemeStyle.Purple));
                                _isSwitched = value;
                              });
                            },
                          ),
                          Icon(Icons.menu),
                        ])
                  : null,
              body: Stack(children: <Widget>[
                SafeArea(child: widget.child),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.showNavBar
                        ? Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: Colors.transparent),
                            child: BottomNavigationBar(
                              elevation: 0,
                              type: BottomNavigationBarType.fixed,
                              showSelectedLabels: false,
                              showUnselectedLabels: false,
                              currentIndex: state.homePageIndex,
                              items: bubbleBar(context, 0, state.theme),
                              onTap: (int index) async {
                                if (index == state.homePageIndex) {
                                  return;
                                }
                                dispatch(AppNavigateAction(index));
                                if (index == 1) {
                                  dispatch(EventsGetAction());
                                } else if (index == 2) {
                                  dispatch(PeopleGetAction());
                                }
                              },
                            ))
                        : null),
                if (_showUserSettings)
                  Column(
                    children: <Widget>[
                      const Button(
                        text: 'Edit my profile',
                        //onPressed: () => dispatch(NavigateAction()),
                      ),
                      Button(
                        text: 'View my profile',
                        onPressed: () {
                          dispatch(NavigateAction<AppState>.pushNamed(
                              ProfileScreen.id));
                          setState(() => _showUserSettings = false);
                        },
                      ),
                    ],
                  )
              ]));
        });
  }
}
