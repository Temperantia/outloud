import 'package:business/app_state.dart';
import 'package:business/permissions/location_permission.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/chats/chats_widget.dart';
import 'package:inclusive/events/events_widget.dart';
import 'package:inclusive/people/people_widget.dart';
import 'package:inclusive/profile/profile_widget.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;
  Widget _body;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(vsync: this, length: 4);
    requestLocationPermission();
    _body = Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(themeStyle == 'orange'
                    ? 'images/screenPattern.png'
                    : 'images/screenPatternPurple.png'),
                fit: BoxFit.cover)),
        child: TabBarView(
            //physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              ProfileWidget(),
              EventsWidget(),
              PeopleWidget(),
              ChatsWidget(),
            ]));
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
                },
              ),
              FlatButton(
                child: const Text('GO to settings'),
                onPressed: () {
                  LocationPermissionService().openAppSettings();
                },
              )
            ],
          );
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
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _buildBody() {
    return _body;
  }

  @override
  Widget build(BuildContext context) {
    //_authService.refreshLocation();
    print('rebuilding home');
    return Selector<AppState, int>(
        selector: (BuildContext context, AppState state) => state.homePageIndex,
        builder: (BuildContext context, int homePageIndex, Widget child) {
          _tabController.animateTo(homePageIndex);

          return View(
            child: _buildBody(),
          );
        });
  }
}
