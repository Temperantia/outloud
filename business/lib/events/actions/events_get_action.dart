import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';
import 'package:business/permissions/location_permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

class EventsGetAction extends redux.ReduxAction<AppState> {
  final Geolocator _geolocator = Geolocator();
  @override
  Future<AppState> reduce() async {
    final List<Event> events = await getEvents();

    final PermissionStatus permission =
        await LocationPermissionService().checkLocationPermissionStatus();
    if (permission == PermissionStatus.granted) {
      try {
        final Position position = await _geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        for (final Event event in events) {
          event.distance = (await _geolocator.distanceBetween(
                  event.location.latitude,
                  event.location.longitude,
                  position.latitude,
                  position.longitude))
              .roundToDouble();
        }
      } catch (error) {
        // TODO(me): handle error
      }
    }

    return state.copy(eventsState: state.eventsState.copy(events: events));
  }
}
