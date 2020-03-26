import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';

class UserLoungeEventUpdateAction extends redux.ReduxAction<AppState> {
  UserLoungeEventUpdateAction(this.event, this.loungeId);

  final Event event;
  final String loungeId;

  @override
  AppState reduce() {
    final List<Lounge> lounges = state.userState.lounges;
    final Lounge lounge =
        lounges.firstWhere((Lounge lounge) => lounge.id == loungeId);
    lounge.event = event;
    return state.copy(userState: state.userState.copy(lounges: lounges));
  }
}
