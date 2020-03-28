import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/lounge_visibility.dart';

class LoungeCreateDetailAction extends ReduxAction<AppState> {
  LoungeCreateDetailAction(this._visibility, this._limit, this._description);

  final LoungeVisibility _visibility;
  final int _limit;
  final String _description;

  @override
  AppState reduce() {
    final Lounge loungeCreation = state.loungesState.loungeCreation
      ..visibility = _visibility
      ..memberLimit = _limit
      ..description = _description;
    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: loungeCreation));
  }
}
