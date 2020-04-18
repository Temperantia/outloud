import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';
import 'package:flutter/widgets.dart';

class LoungeCreateDetailAction extends ReduxAction<AppState> {
  LoungeCreateDetailAction(this._visibility, this._limit, this._description);

  final LoungeVisibility _visibility;
  final int _limit;
  final String _description;

  @override
  Future<AppState> reduce() async {
    final Lounge loungeCreation =
        await createLounge(state.loungesState.loungeCreation
          ..visibility = _visibility
          ..memberLimit = _limit
          ..description = _description);

    final User user = state.userState.user..lounges.add(loungeCreation.id);

    updateUser(user);

    final Map<String, Map<String, ChatState>> loungesChatsStates =
        state.chatsState.loungesChatsStates;

    loungesChatsStates[state.userState.user.id]
        .putIfAbsent(loungeCreation.id, () => ChatState());

    dispatch(NavigateAction<AppState>.pushNamedAndRemoveUntil(
        'LoungeChatScreen',
        arguments: loungeCreation,
        predicate: (Route<dynamic> route) => route.isFirst));

    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: loungeCreation));
  }
}
