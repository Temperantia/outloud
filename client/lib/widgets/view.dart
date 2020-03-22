import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/actions/app_disconnect_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/profile/profile_edition_screen.dart';
import 'package:inclusive/profile/profile_screen.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class View extends StatefulWidget {
  const View(
      {@required this.child,
      this.showAppBar = true,
      this.showNavBar = true,
      this.title = '',
      this.isRoot = false,
      this.onBack,
      this.backIcon = Icons.keyboard_arrow_left});

  final Widget child;
  final bool showAppBar;
  final bool showNavBar;
  final bool isRoot;
  final String title;
  final void Function() onBack;
  final IconData backIcon;

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  bool _showUserSettings = false;

  Widget _buildBody(
      AppState state, void Function(ReduxAction<dynamic>) dispatch) {
    EdgeInsetsGeometry margin;
    if (widget.isRoot) {
      margin = const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 50.0);
    } else if (widget.showAppBar && widget.showNavBar) {
      margin = const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 50.0);
    }

    return SafeArea(
        child: Stack(children: <Widget>[
      Row(children: <Widget>[
        Expanded(child: Image.asset('images/screenFull.png', fit: BoxFit.fill))
      ]),
      if (widget.showNavBar) _buildNavBar(state, dispatch),
      if (widget.showAppBar) _buildAppBar(state.userState.user, dispatch),
      Container(margin: margin, child: widget.child),
    ]));
  }

  Widget _buildAppBar(User user, void Function(ReduxAction<dynamic>) dispatch) {
    return Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: 40.0,
                    height: 40.0,
                    child: Image.asset('images/OL-draft1aWhite.png')),
                if (user == null)
                  const CircularProgressIndicator()
                else
                  GestureDetector(
                      onTap: () => setState(
                          () => _showUserSettings = !_showUserSettings),
                      child: CircularImage(
                          imageRadius: 40.0,
                          imageUrl: user.pics.isEmpty ? null : user.pics[0])),
                Icon(Icons.menu),
              ])),
      if (_showUserSettings || !widget.isRoot)
        Container(
            child: Stack(children: <Widget>[
          if (_showUserSettings) _buildUserSettings(user, dispatch),
          if (!widget.isRoot)
            Stack(children: <Widget>[
              GestureDetector(
                  onTap: widget.onBack ??
                      () => dispatch(NavigateAction<AppState>.pop()),
                  child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Icon(widget.backIcon, color: white))),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.title,
                        textAlign: TextAlign.center, style: textStyleTitleAlt),
                  ]),
            ])
        ])),
    ]);
  }

  Widget _buildUserSettings(
      User user, void Function(ReduxAction<dynamic>) dispatch) {
    return Column(children: <Widget>[
      Button(
          text: 'Edit my profile',
          onPressed: () {
            dispatch(
                NavigateAction<AppState>.pushNamed(ProfileEditionScreen.id));
            setState(() => _showUserSettings = false);
          }),
      Button(
          text: 'View my profile',
          onPressed: () {
            dispatch(NavigateAction<AppState>.pushNamed(ProfileScreen.id,
                arguments: user));
            setState(() => _showUserSettings = false);
          }),
      Button(
          text: 'Disconnect',
          onPressed: () {
            Navigator.of(context)
                .popUntil((Route<dynamic> route) => route.isFirst);
            dispatch(AppDisconnectAction());
            setState(() => _showUserSettings = false);
          }),
    ]);
  }

  Widget _buildNavBar(
      AppState state, void Function(ReduxAction<dynamic>) dispatch) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: widget.showNavBar
            ? Theme(
                data:
                    Theme.of(context).copyWith(canvasColor: Colors.transparent),
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
                      }
                      Navigator.of(context)
                          .popUntil((Route<dynamic> route) => route.isFirst);
                    }))
            : null);
  }

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
          return Scaffold(body: _buildBody(state, dispatch));
        });
  }
}
