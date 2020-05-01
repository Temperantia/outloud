import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/events/actions/events_get_action.dart';
// import 'package:business/lounges/actions/lounges_listen_action.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/user/actions/user_listen_action.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String id = user?.uid;

    if (id != null) {
      await dispatchFuture(UserListenAction(id));
    }
    await dispatchFuture(EventsGetAction());
    await dispatchFuture(PeopleGetAction());

    return state.copy(
        loginState: state.loginState.copy(id: id), loading: false);
  }
}
