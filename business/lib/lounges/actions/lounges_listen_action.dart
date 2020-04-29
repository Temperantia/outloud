import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/lounges/actions/lounges_update_action.dart';
import 'package:business/models/lounges.dart';

class LoungesListenAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    streamLounges().listen((List<Lounge> lounges) {
      dispatch(LoungesUpdateAction(lounges));
    });
    return null;
  }
}
