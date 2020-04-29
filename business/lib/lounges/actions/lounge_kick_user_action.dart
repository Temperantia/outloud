import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class LoungeKickUserAction extends ReduxAction<AppState> {
  LoungeKickUserAction(this.userId, this.lounge);

  final String userId;
  final Lounge lounge;

  @override
  Future<AppState> reduce() async {
    if (!lounge.memberIds.contains(userId)) {
      return null;
    }
    final User _user = await getUser(userId);

    await updateLoungeUser(lounge..memberIds.remove(userId));
    await updateUserLounge(_user, _user.lounges..remove(lounge.id));

    final Map<String, Map<String, ChatState>> loungesChatsStates =
        state.chatsState.loungesChatsStates;

    loungesChatsStates[state.userState.user.id].remove(lounge.id);

    return state;
  }
}
