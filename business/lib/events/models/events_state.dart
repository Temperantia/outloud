import 'package:business/classes/event.dart';
import 'package:business/classes/event_group.dart';

class EventsState {
  EventsState({
    this.events,
    this.event,
    this.groups,
  });

  EventsState copy({
    List<Event> events,
    Event event,
    List<EventGroup> groups,
  }) =>
      EventsState(
        events: events ?? this.events,
        event: event ?? this.event,
        groups: groups ?? this.groups,
      );

  final List<Event> events;
  final Event event;
  final List<EventGroup> groups;

  static EventsState initialState() {
    return EventsState(
      events: null,
      event: null,
      groups: null,
    );
  }
}
