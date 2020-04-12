import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';

class LoungeCreateAction extends ReduxAction<AppState> {
  LoungeCreateAction(this._eventId);

  final String _eventId;

  @override
  AppState reduce() {
    final String userId = state.loginState.id;

    final Lounge loungeCreation =
        Lounge(memberIds: <String>[userId], owner: userId, eventId: _eventId);
    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: loungeCreation));
  }
}
