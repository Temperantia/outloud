import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/lounges/actions/lounges_listen_action.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/user/actions/user_listen_stream_action.dart';
import 'package:business/user/actions/user_get_friends_action.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String id = user == null ? null : user.uid;

    if (id != null) {
      store.dispatch(UserListenStreamAction(id));
      store.dispatch(ChatsListenAction(id));
      store.dispatch(UserGetFriendsAction(id)); // TODO(me): a stream rather
    }
    store.dispatch(EventsGetAction());
    store.dispatch(LoungesListenAction());
    store.dispatch(PeopleGetAction());

    return state.copy(
        loginState: state.loginState.copy(id: id), loading: false);
  }
}
