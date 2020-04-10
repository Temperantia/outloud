import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:business/app_persistor.dart';
import 'package:business/app_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:outloud/home_screen.dart';
import 'package:outloud/register/login.dart';
import 'package:business/login/actions/login_action.dart';
import 'package:outloud/routes.dart';

import 'package:outloud/theme.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

Store<AppState> store;
GlobalKey<NavigatorState> navigatorKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: orange));

  final AppPersistor persistor = AppPersistor();
  AppState initialState = await persistor.readState();

  if (initialState == null) {
    initialState = AppState.initialState();
    await persistor.saveInitialState(initialState);
  }

  store = Store<AppState>(
    persistor: persistor,
    initialState: initialState,
    errorObserver: DevelopmentErrorObserver<
        AppState>(), // TODO(me): change this for release
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
  @override
  Widget build(BuildContext context) {
    return AsyncReduxProvider<AppState>.value(
        value: store,
        child: ReduxSelector<AppState, dynamic>(
            selector: (BuildContext context, AppState state) =>
                <dynamic>[state.loading, state.userState.user, state.theme],
            builder: (BuildContext context,
                Store<AppState> store,
                AppState state,
                void Function(ReduxAction<dynamic>) dispatch,
                dynamic model,
                Widget child) {
              return MaterialApp(
                  localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                    FlutterI18nDelegate(
                        translationLoader: FileTranslationLoader()),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  debugShowCheckedModeBanner: false,
                  theme: theme(state.theme),
                  title: 'Inc•lusive',
                  home: state.loading
                      ? Loading()
                      : state.userState.user == null
                          ? LoginScreen()
                          : HomeScreen(),
                  navigatorKey: navigatorKey,
                  onGenerateRoute: (RouteSettings settings) =>
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              routes[settings.name](settings.arguments)));
            }));
  }
}
