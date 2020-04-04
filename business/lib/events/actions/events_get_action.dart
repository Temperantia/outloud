import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_event_update_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/event_members_update_action.dart';
import 'package:business/models/event_message.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

class EventsGetAction extends redux.ReduxAction<AppState> {
  static final List<StreamSubscription<List<User>>> _membersSubs =
      <StreamSubscription<List<User>>>[];
  static final List<StreamSubscription<List<Message>>> _messagesSubs =
      <StreamSubscription<List<Message>>>[];

  @override
  Future<AppState> reduce() async {
    final List<Event> events = await getEvents();

    final PermissionStatus permission =
        await permissionLocation.checkLocationPermissionStatus();
    if (permission == PermissionStatus.granted) {
      try {
        final Position position = await geoLocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        for (final Event event in events) {
          event.distance = event.location == null
              ? null
              : (await geoLocator.distanceBetween(
                      event.location.latitude,
                      event.location.longitude,
                      position.latitude,
                      position.longitude))
                  .roundToDouble();
        }
        events.sort((Event eventA, Event eventB) {
          if (eventA.dateStart.isBefore(eventB.dateStart)) {
            return -1;
          } else if (eventA.dateStart.isAfter(eventB.dateStart)) {
            return 1;
          }
          return 0;
        });
      } catch (error) {
        // TODO(me): handle error
      }
    }

    _streamUsers(events);
    _streamMessages(events);

    return state.copy(eventsState: state.eventsState.copy(events: events));
  }

  void _streamUsers(List<Event> events) {
    for (final StreamSubscription<List<User>> memberSub in _membersSubs) {
      memberSub.cancel();
    }
    _membersSubs.clear();

    for (final Event event in events) {
      _membersSubs.add(streamUsers(ids: event.memberIds).listen(
          (List<User> members) =>
              dispatch(EventMembersUpdateAction(members, event.id))));
    }
  }

  void _streamMessages(List<Event> events) {
    for (final StreamSubscription<List<Message>> messageSub in _messagesSubs) {
      messageSub.cancel();
    }
    _messagesSubs.clear();

    final List<Chat> chats = <Chat>[];
    for (final Event event in events) {
      final Chat chat = Chat(event.id, state.loginState.id);
      chats.add(chat);
      _messagesSubs.add(streamEventMessages(chat.id).listen(
          (List<Message> messages) =>
              dispatch(ChatsEventUpdateAction(messages, chat.id))));
    }
  }
}
