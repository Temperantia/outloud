import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';

class UserLoungeEventUpdateAction extends redux.ReduxAction<AppState> {
  UserLoungeEventUpdateAction(this._event, this._loungeId);

  final Event _event;
  final String _loungeId;

  @override
  AppState reduce() {
    final List<Lounge> lounges = state.userState.lounges;
    final Lounge lounge = lounges.firstWhere(
        (Lounge lounge) => lounge.id == _loungeId,
        orElse: () => null);

    if (lounge == null) {
      return null;
    }

    lounge.event = _event;
    return state.copy(userState: state.userState.copy(lounges: lounges));
  }
}
