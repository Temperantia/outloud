import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class AppUpdateThemeAction extends ReduxAction<AppState> {
  AppUpdateThemeAction(this.themeStyle);

  final ThemeStyle themeStyle;

  @override
  AppState reduce() {
    return state.copy(theme: themeStyle);
  }
}
