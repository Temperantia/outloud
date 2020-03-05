import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';

class LoungesUpdateAction extends ReduxAction<AppState> {
  LoungesUpdateAction(this.lounges);
  final List<Lounge> lounges;
  @override
  AppState reduce() {
    return state.copy(loungesState: state.loungesState.copy(lounges: lounges));
  }
}
