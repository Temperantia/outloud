import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/actions/app_update_theme_action.dart';
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

  AppBar _buildAppBar(User user, void Function(ReduxAction<dynamic>) dispatch) {
    return AppBar(
        centerTitle: true,
        title: user == null
            ? const CircularProgressIndicator()
            : GestureDetector(
                onTap: () =>
                    setState(() => _showUserSettings = !_showUserSettings),
                child: CircularImage(
                    imageRadius: 40.0,
                    imageUrl: user.pics.isEmpty ? null : user.pics[0])),
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
                dispatch(AppUpdateThemeAction(
                    _isSwitched ? ThemeStyle.Orange : ThemeStyle.Purple));
                _isSwitched = value;
              });
            },
          ),
          Icon(Icons.menu),
        ]);
  }

  Widget _buildBody(
      AppState state, void Function(ReduxAction<dynamic>) dispatch) {
    return Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(state.theme == ThemeStyle.Orange
                      ? 'images/screenPattern.png'
                      : 'images/screenPatternPurple.png'),
                  fit: BoxFit.cover)),
          child: Container(
              margin: const EdgeInsets.only(bottom: 50.0),
              child: SafeArea(child: widget.child))),
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
                      }
                      Navigator.of(context)
                          .popUntil((Route<dynamic> route) => route.isFirst);
                    },
                  ))
              : null),
      if (_showUserSettings)
        Column(
          children: <Widget>[
            Button(
              text: 'Edit my profile',
              onPressed: () {
                dispatch(NavigateAction<AppState>.pushNamed(
                    ProfileEditionScreen.id));
                setState(() => _showUserSettings = false);
              },
            ),
            Button(
              text: 'View my profile',
              onPressed: () {
                dispatch(NavigateAction<AppState>.pushNamed(ProfileScreen.id,
                    arguments: state.userState.user));
                setState(() => _showUserSettings = false);
              },
            ),
            Button(
              text: 'Disconnect',
              onPressed: () {
                Navigator.of(context)
                    .popUntil((Route<dynamic> route) => route.isFirst);
                dispatch(AppDisconnectAction());
                setState(() => _showUserSettings = false);
              },
            ),
          ],
        )
    ]);
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
          final User user = state.userState.user;
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: widget.showAppBar ? _buildAppBar(user, dispatch) : null,
              body: _buildBody(state, dispatch));
        });
  }
}
