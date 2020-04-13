import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class LoungeRemoveAction extends ReduxAction<AppState> {
  LoungeRemoveAction(this.lounge);

  final Lounge lounge;

  @override
  Future<AppState> reduce() async {
    for (final User _user in lounge.members) {
      updateUserLounge(_user, _user.lounges..remove(lounge.id));
      // updateUser(_user);
    }

    final Map<String, Map<String, ChatState>> loungesChatsStates =
        state.chatsState.loungesChatsStates;

    loungesChatsStates[state.userState.user.id].remove(lounge.id);

    for (final User _user in lounge.members) {
      updateUserLounge(_user, _user.lounges..remove(lounge.id));
    }

    await deleteLounge(lounge);

    return null;
  }
}
