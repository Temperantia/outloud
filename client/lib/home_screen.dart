import 'package:async_redux/async_redux.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/permissions/location_permission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        ChangeNotifier {
  TabController _tabController;
  User _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(vsync: this, length: 4);
    requestLocationPermission();
  }

  Future<bool> requestLocationPermission() async {
    final bool granted =
        await LocationPermissionService().requestLocationPermission();
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
                      LocationPermissionService().openAppSettings();
                    }),
              ]);
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        _refreshLocation();
        break;
    }
  }

  Future<void> _refreshLocation() async {
    if (_user != null) {
      return;
    }
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _user.location = GeoPoint(position.latitude, position.longitude);
    updateUser(_user);
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
          _user = state.userState.user;
          _refreshLocation();

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
