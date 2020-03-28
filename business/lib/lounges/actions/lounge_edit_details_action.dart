import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:business/models/lounges.dart';

class LoungeEditDetailsAction extends ReduxAction<AppState> {
  LoungeEditDetailsAction(
      this._lounge, this._visibility, this._limit, this._description);

  final Lounge _lounge;
  final LoungeVisibility _visibility;
  final int _limit;
  final String _description;

  @override
  AppState reduce() {
    _lounge
      ..visibility = _visibility
      ..memberLimit = _limit
      ..description = _description;

    updateLounge(_lounge);

    return null;
  }
}
