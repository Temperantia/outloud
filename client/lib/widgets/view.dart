import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/actions/app_update_theme_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/profile/profile_edition_screen.dart';

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
  bool isSwitched = false;
  bool _showUserSettings = false;

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, dynamic>(
        selector: (BuildContext context, AppState state) =>
            <dynamic>[state.userState.user, state.homePageIndex],
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
                              child: CircularImage(
                                  imageRadius: 40.0,
                                  imageUrl:
                                      user.pics.isEmpty ? null : user.pics[0])),
                      leading: Navigator.canPop(context)
                          ? GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child:
                                  Icon(Icons.keyboard_arrow_left, color: white))
                          : null,
                      actions: <Widget>[
                          Switch(
                            value: isSwitched,
                            onChanged: (bool value) {
                              setState(() {
                                dispatch(AppUpdateThemeAction(isSwitched
                                    ? ThemeStyle.Orange
                                    : ThemeStyle.Purple));
                                isSwitched = value;
                              });
                            },
                          ),
                          Icon(Icons.menu),
                        ])
                  : null,
              bottomNavigationBar: widget.showNavBar
                  ? BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      currentIndex: state.homePageIndex,
                      items: bubbleBar(context, 0),
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
                        Navigator.of(context)
                            .popUntil((Route<dynamic> route) => route.isFirst);
                      },
                    )
                  : null,
              body: Stack(children: [
                SafeArea(child: widget.child),
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
                    ],
                  )
              ]));
        });
  }
}
