import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/login/auth.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/user/actions/user_listen_stream_action.dart';

class LoginAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final String id = await autoLogin();
    if (id != null) {
      store.dispatch(UserListenStreamAction(id));
      store.dispatch(ChatsListenAction(id));
    }
    store.dispatch(EventsGetAction());
    store.dispatch(PeopleGetAction());

    return state.copy(
        loginState: state.loginState.copy(id: id), loading: false);
  }
}
