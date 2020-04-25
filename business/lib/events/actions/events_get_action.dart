import 'dart:async';

import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_event_update_action.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/events/actions/event_members_update_action.dart';
import 'package:business/models/event_message.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class EventsGetAction extends ReduxAction<AppState> {
  static final List<StreamSubscription<List<User>>> _membersSubs =
      <StreamSubscription<List<User>>>[];
  static final List<StreamSubscription<List<Message>>> _messagesSubs =
      <StreamSubscription<List<Message>>>[];

  @override
  Future<AppState> reduce() async {
    final List<Event> events = await getEvents();

    /*  final PermissionStatus permission =
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
                      .roundToDouble() /
                  1000;
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
    } */

    for (final Event event in events) {
      if (event.pic.contains('.mp4')) {
        event.thumbnail = await VideoThumbnail.thumbnailFile(
            video: event.pic,
            thumbnailPath: (await getTemporaryDirectory()).path,
            maxWidth: 1000,
            imageFormat: ImageFormat.PNG,
            quality: 75);
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

    for (final StreamSubscription<List<User>> memberSub
        in ChatsEventUpdateAction.memberSubs) {
      memberSub.cancel();
    }
    ChatsEventUpdateAction.memberSubs.clear();

    for (final Event event in events) {
      _messagesSubs.add(streamEventMessages(event.id).listen(
          (List<Message> messages) =>
              dispatch(ChatsEventUpdateAction(messages, event.id))));
    }
  }
}
