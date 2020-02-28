import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/actions/app_update_theme_action.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, int>(
        selector: (BuildContext context, AppState state) => state.homePageIndex,
        builder: (BuildContext context,
                Store<AppState> store,
                AppState state,
                void Function(ReduxAction<dynamic>) dispatch,
                int homePageIndex,
                Widget w) =>
            Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: widget.showAppBar
                    ? AppBar(
                        centerTitle: true,
                        title: Text(widget.title,
                            style: Theme.of(context).textTheme.caption),
                        leading: Navigator.canPop(context)
                            ? GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(Icons.keyboard_arrow_left,
                                    color: white))
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
                        currentIndex: homePageIndex,
                        items: bubbleBar(context, 0),
                        onTap: (int index) async {
                          if (index == homePageIndex) {
                            return;
                          }
                          dispatch(AppNavigateAction(index));
                          if (index == 1) {
                            dispatch(EventsGetAction());
                          } else if (index == 2) {
                            dispatch(PeopleGetAction());
                          }
                        },
                      )
                    : null,
                body: SafeArea(child: widget.child)));
  }
}
