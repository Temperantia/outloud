import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/lounge_visibility.dart';

class LoungeCreateDetailAction extends ReduxAction<AppState> {
  LoungeCreateDetailAction(this.visibility, this.limit, this.description);

  final LoungeVisibility visibility;
  final int limit;
  final String description;

  @override
  AppState reduce() {
    final Lounge loungeCreation = state.loungesState.loungeCreation
      ..visibility = visibility
      ..memberLimit = limit
      ..description = description;
    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: loungeCreation));
  }
}
