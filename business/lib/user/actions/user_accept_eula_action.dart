import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';

class UserAcceptEulaAction extends ReduxAction<AppState> {
  UserAcceptEulaAction();

  @override
  AppState reduce() {
    return state.copy(acceptedEula: true);
  }
}
