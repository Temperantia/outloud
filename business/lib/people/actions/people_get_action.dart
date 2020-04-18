import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

class PeopleGetAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final List<User> people = await getUsers(state.loginState.id);
/*     GeoPoint location;
    if (state.userState.user != null) {
      location = state.userState.user.location;
    } else {
      final Position position = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      location = GeoPoint(position.latitude, position.longitude);
    }
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
 */
    return state.copy(
        peopleState: state.peopleState
            .copy(people: people /* , distances: distances */));
  }
}
