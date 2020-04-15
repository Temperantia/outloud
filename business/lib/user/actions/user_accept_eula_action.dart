import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';

class UserAcceptEulaAction extends redux.ReduxAction<AppState> {
  UserAcceptEulaAction();

  @override
  AppState reduce() {
    return state.copy(acceptedEula: true);
  }
}