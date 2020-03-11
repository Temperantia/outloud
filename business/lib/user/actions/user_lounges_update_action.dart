import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';

class UserLoungesUpdateAction extends redux.ReduxAction<AppState> {
  UserLoungesUpdateAction(this.lounges);
  final List<Lounge> lounges;
  @override
  AppState reduce() {
    return state.copy(userState: state.userState.copy(lounges: lounges));
  }
}
