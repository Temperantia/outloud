import 'package:async_redux/async_redux.dart';
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/actions/app_update_theme_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:flutter/material.dart';
import 'package:business/app_persistor.dart';
import 'package:business/app_state.dart';
import 'package:inclusive/home_screen.dart';
import 'package:inclusive/profile/profile_screen.dart';
import 'package:inclusive/register/login.dart';
import 'package:business/login/actions/login_action.dart';
import 'package:inclusive/routes.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/bubble_bar.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

Store<AppState> store;
GlobalKey<NavigatorState> navigatorKey;

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    final ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 1000; // 1000 MB
    return imageCache;
  }
}

Future<void> main() async {
  CustomImageCache();

  WidgetsFlutterBinding.ensureInitialized();

  final AppPersistor persistor = AppPersistor();
  AppState initialState = await persistor.readState();

  if (initialState == null) {
    initialState = AppState.initialState();
    await persistor.saveInitialState(initialState);
  }

  store = Store<AppState>(
    persistor: persistor,
    initialState: initialState,
    errorObserver: DevelopmentErrorObserver<AppState>(),
  );

  store.dispatch(LoginAction());

  navigatorKey = GlobalKey<NavigatorState>();
  NavigateAction.setNavigatorKey(navigatorKey);

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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

  Widget _buildBody(Widget child, AppState state,
      void Function(ReduxAction<dynamic>) dispatch) {
    return Stack(children: <Widget>[
      SafeArea(child: child),
      Align(
          alignment: Alignment.bottomCenter,
          child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
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
                },
              ))),
      if (_showUserSettings)
        Column(children: <Widget>[
          const Button(
            text: 'Edit my profile',
            //onPressed: () => dispatch(NavigateAction()),
          ),
          Button(
              text: 'View my profile',
              onPressed: () {
                dispatch(NavigateAction<AppState>.pushNamed(ProfileScreen.id));
                setState(() => _showUserSettings = false);
              }),
        ])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AsyncReduxProvider<AppState>.value(
        value: store,
        child: ReduxSelector<AppState, dynamic>(
            selector: (BuildContext context, AppState state) =>
                <dynamic>[state.loading, state.loginState.id, state.theme],
            builder: (BuildContext context,
                Store<AppState> store,
                AppState state,
                void Function(ReduxAction<dynamic>) dispatch,
                dynamic model,
                Widget child) {
              final User user = state.userState.user;

              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme(state.theme),
                  title: 'Inc•lusive',
                  /*
                  home: Builder(builder: (BuildContext context) {
                    print('build');
                    if (state.loading) {
                      return Loading();
                    }
                    if (state.loginState.id == null) {
                      return LoginScreen();
                    }
                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: _buildAppBar(user, dispatch),
                      body: _buildBody(HomeScreen(), state, dispatch),
                    );
                    return HomeScreen();
                  }),
                  */
                  navigatorKey: navigatorKey,
                  onGenerateRoute: (RouteSettings settings) =>
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => Scaffold(
                                resizeToAvoidBottomInset: false,
                                appBar: _buildAppBar(user, dispatch),
                                body: _buildBody(
                                    routes[settings.name], state, dispatch),
                              )));
            }));
  }
}
