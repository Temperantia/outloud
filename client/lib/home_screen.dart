import 'package:async_redux/async_redux.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/app_state.dart';
import 'package:business/singletons/permission_location.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/events/events_widget.dart';
import 'package:inclusive/home_widget.dart';
import 'package:inclusive/lounges/lounges_widget.dart';
import 'package:inclusive/people/people_widget.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, ChangeNotifier {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    requestLocationPermission();
  }

  Future<bool> requestLocationPermission() async {
    final bool granted = await PermissionLocation().requestLocationPermission();
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  void onPermissionDenied() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('PERMISSION WARNING'),
              content: const Text('YOU SHOULD ALLOW LOCATION PERMISSION !'),
              actions: <Widget>[
                FlatButton(
                    child: const Text('NO, THANKS'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: const Text('GO to settings'),
                    onPressed: () {
                      PermissionLocation().openAppSettings();
                    }),
              ]);
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose(); // TODO(me): this thing bugs
  }

  Widget _buildBody() {
    return TabBarView(controller: _tabController, children: <Widget>[
      HomeWidget(),
      EventsWidget(),
      LoungesWidget(),
      PeopleWidget(),
    ]);
  }

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
            Widget child) {
          if (!_tabController.hasListeners) {
            _tabController.addListener(() {
              if (!_tabController.indexIsChanging &&
                  _tabController.previousIndex != _tabController.index) {
                dispatch(AppNavigateAction(_tabController.index));
              }
            });
          }
          _tabController.animateTo(state.homePageIndex);

          return View(child: _buildBody(), isRoot: true);
        });
  }
}
