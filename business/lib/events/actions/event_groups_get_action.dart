import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event_group.dart';
import 'package:business/models/events.dart';

class EventGroupsGetAction extends redux.ReduxAction<AppState> {
  EventGroupsGetAction(this.eventId);

  final String eventId;

  @override
  Future<AppState> reduce() async {
    final List<EventGroup> groups = await getEventGroups(eventId);
    for (final EventGroup group in groups) {
      await group.getMembers();
    }

    return state.copy(
        eventsState: state.eventsState
            .copy(groups: groups, group: groups.isEmpty ? null : groups[0]));
  }
}
