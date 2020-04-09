import 'package:business/classes/event.dart';

class EventsState {
  EventsState({this.events});

  EventsState copy({List<Event> events}) =>
      EventsState(events: events ?? this.events);

  final List<Event> events;

  static EventsState initialState() => EventsState();
}
