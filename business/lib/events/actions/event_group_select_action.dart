import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event_group.dart';

class EventGroupSelectAction extends redux.ReduxAction<AppState> {
  EventGroupSelectAction(this.group);
  final EventGroup group;

  @override
  AppState reduce() {
    return state.copy(eventsState: state.eventsState.copy(group: group));
  }
}
