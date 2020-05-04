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
import 'package:outloud/widgets/error_widget.dart';
import 'package:outloud/widgets/eula_widget.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

Store<AppState> store;
GlobalKey<NavigatorState> navigatorKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));

  final AppPersistor persistor = AppPersistor();
  AppState initialState = await persistor.readState();

  if (initialState == null) {
    initialState = AppState.initialState();
    await persistor.saveInitialState(initialState);
  }

  store = Store<AppState>(
      persistor: persistor,
      initialState: initialState,
      errorObserver: SwallowErrorObserver<AppState>());

  await store.dispatchFuture(LoginAction());

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
            selector: (BuildContext context, AppState state) => <dynamic>[
                  state.loading,
                  state.userState.user,
                  state.theme,
                  state.acceptedEula,
                  state.loginState.loginError
                ],
            builder: (BuildContext context,
                Store<AppState> store,
                AppState state,
                void Function(ReduxAction<AppState>) dispatch,
                dynamic model,
                Widget child) {
              print(state.userState.user?.name);
              return MaterialApp(
                  localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                    FlutterI18nDelegate(
                        translationLoader:
                            FileTranslationLoader(fallbackFile: 'fr')),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  debugShowCheckedModeBanner: false,
                  theme: theme(state.theme),
                  title: 'Inc•lusive',
                  home: !state.acceptedEula
                      ? EulaWidget()
                      : state.loginState.loginError.isNotEmpty
                          ? MyErrorWidget(state.loginState.loginError)
                          : state.loading
                              ? const Loading()
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
