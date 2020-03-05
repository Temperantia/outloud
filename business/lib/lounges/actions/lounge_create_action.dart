import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';

class LoungeCreateAction extends ReduxAction<AppState> {
  LoungeCreateAction(this.loungeCreation);

  final Lounge loungeCreation;

  @override
  AppState reduce() {
    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: loungeCreation));
  }
}
