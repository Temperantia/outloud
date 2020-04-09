import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class AppSwitchEventsTab extends ReduxAction<AppState> {
  AppSwitchEventsTab(this._index);

  final int _index;

  @override
  AppState reduce() {
    return state.copy(eventsTabIndex: _index);
  }
}
