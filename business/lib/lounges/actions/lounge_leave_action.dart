import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class LoungeLeaveAction extends ReduxAction<AppState> {
  LoungeLeaveAction(this.userId, this.lounge);

  final String userId;
  final Lounge lounge;

  @override
  Future<AppState> reduce() async {
    if (!lounge.memberIds.contains(userId)) {
      return null;
    }

    await updateLoungeUser(lounge..memberIds.remove(userId));

    state.userState..lounges.remove(lounge);
    await updateUser(state.userState.user..lounges.remove(lounge.id));

    final Map<String, Map<String, ChatState>> loungesChatsStates =
        state.chatsState.loungesChatsStates;

    loungesChatsStates[state.userState.user.id].remove(lounge.id);

    return state.copy(
        userState: state.userState.copy(
            user: state.userState.user, lounges: state.userState.lounges));
  }
}
