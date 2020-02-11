import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/home.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class View extends StatelessWidget {
  const View(
      {@required this.child,
      this.showAppBar = true,
      this.showNavBar = true,
      this.title = '',
      this.actions = const <Widget>[]});
  final Widget child;
  final bool showAppBar;
  final bool showNavBar;
  final String title;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(
        builder: (BuildContext context, Store<AppState> store, AppState state,
                void Function(ReduxAction<dynamic>) dispatch, Widget w) =>
            Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: showAppBar
                    ? AppBar(
                        centerTitle: true,
                        title: Text(title,
                            style: Theme.of(context).textTheme.caption),
                        leading: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child:
                                Icon(Icons.keyboard_arrow_left, color: white)),
                        actions: actions)
                    : null,
                bottomNavigationBar: showNavBar
                    ? BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        currentIndex: state.homePageIndex,
                        items: bubbleBar(context, 0),
                        onTap: (int index) {
                          dispatch(AppNavigateAction(index));
                          if (showAppBar) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                HomeScreen.id,
                                (Route<dynamic> route) => route.isCurrent &&
                                        route.settings.name == HomeScreen.id
                                    ? false
                                    : true);
                          }
                        },
                      )
                    : null,
                body: SafeArea(child: child)));
  }
}
