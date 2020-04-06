import 'package:async_redux/async_redux.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/app.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/events/events_widget.dart';
import 'package:outloud/home_widget.dart';
import 'package:outloud/lounges/lounges_widget.dart';
import 'package:outloud/people/people_widget.dart';
import 'package:outloud/widgets/view.dart';
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
    _requestLocationPermission();
  }

  Future<bool> _requestLocationPermission() async {
    final bool granted = await permissionLocation.requestLocationPermission();
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
              title: Text(
                  FlutterI18n.translate(context, 'HOME.PERMISSION_WARNING')),
              content:
                  Text(FlutterI18n.translate(context, 'HOME.ALLOW_PERMISSION')),
              actions: <Widget>[
                FlatButton(
                    child: Text(FlutterI18n.translate(context, 'HOME.REFUSE')),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child:
                        Text(FlutterI18n.translate(context, 'HOME.SETTINGS')),
                    onPressed: () {
                      permissionLocation.openAppSettings();
                    })
              ]);
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
