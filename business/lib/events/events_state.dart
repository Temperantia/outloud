import 'package:business/classes/event.dart';

class EventsState {
  EventsState({this.events, this.event});

  EventsState copy({List<Event> events, Event event}) => EventsState(
        events: events ?? this.events,
        event: event ?? this.event,
      );

  final List<Event> events;
  final Event event;

  static EventsState initialState() => EventsState();
}
