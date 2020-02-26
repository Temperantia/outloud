import 'package:async_redux/async_redux.dart';
import 'package:business/user/actions/user_listen_stream_action.dart';
import 'package:flutter/material.dart';
import 'package:business/app_persistor.dart';
import 'package:business/app_state.dart';
import 'package:inclusive/home_screen.dart';
import 'package:inclusive/register/login.dart';
import 'package:business/login/actions/login_action.dart';
import 'package:inclusive/routes.dart';

import 'package:inclusive/theme.dart';
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

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AsyncReduxProvider<AppState>.value(
        value: store,
        child: ReduxSelector<AppState, dynamic>(
            selector: (BuildContext context, AppState state) =>
                <dynamic>[state.loading, state.loginState.id],
            builder: (BuildContext context,
                Store<AppState> store,
                AppState state,
                void Function(ReduxAction<dynamic>) dispatch,
                dynamic model,
                Widget child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  title: 'Inc•lusive',
                  home: Builder(builder: (BuildContext context) {
                    if (state.loading) {
                      return Loading();
                    }
                    if (state.loginState.id == null) {
                      return LoginScreen();
                    }
                    return HomeScreen();
                  }),
                  navigatorKey: navigatorKey,
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => routes[settings.name],
                    );
                  });
            }));
  }
}
