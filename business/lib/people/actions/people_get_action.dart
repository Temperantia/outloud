import 'package:async_redux/async_redux.dart';
import 'package:business/app.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class PeopleGetAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final List<User> people = await getUsers(state.loginState.id);

    final GeoPoint location = state.userState.user.location;
    final Map<String, String> distances = <String, String>{};
    for (final User person in people) {
      if (location != null && person.location != null) {
        final int distance = await geoLocator.distanceBetween(
                location.latitude,
                location.longitude,
                person.location.latitude,
                person.location.longitude) ~/
            1000;
        if (distance > 3000) {
          try {
            final List<Placemark> address =
                await geoLocator.placemarkFromCoordinates(
                    person.location.latitude, person.location.longitude);
            distances[person.id] = address[0].country;
          } catch (error) {
            distances[person.id] = '${distance.toString()} km';
          }
        } else {
          distances[person.id] = '${distance.toString()} km';
        }
      }
    }

    return state.copy(
        peopleState:
            state.peopleState.copy(people: people, distances: distances));
  }
}
