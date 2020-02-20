import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class AppInitStateAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return state.copy();
  }
}
