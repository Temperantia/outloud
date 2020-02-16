import 'package:business/classes/event.dart';
import 'package:business/classes/event_group.dart';

class EventsState {
  EventsState({
    this.events,
    this.event,
    this.groups,
    this.group,
  });

  EventsState copy({
    List<Event> events,
    Event event,
    List<EventGroup> groups,
    EventGroup group,
  }) =>
      EventsState(
        events: events ?? this.events,
        event: event ?? this.event,
        groups: groups ?? this.groups,
        group: group ?? this.group,
      );

  final List<Event> events;
  final Event event;
  final List<EventGroup> groups;
  final EventGroup group;

  static EventsState initialState() {
    return EventsState(
      events: null,
      event: null,
      groups: null,
      group: null,
    );
  }
}
