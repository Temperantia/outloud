import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class AppNavigateAction extends ReduxAction<AppState> {
  AppNavigateAction(this._index);

  final int _index;

  @override
  AppState reduce() {
    return state.copy(homePageIndex: _index);
  }
}
