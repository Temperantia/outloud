import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:business/login/actions/login_google_action.dart';
import 'package:business/app_state.dart';
import 'package:inclusive/register/login.dart';

class LoginConnectorWidget extends StatelessWidget {
  static const String id = 'Login';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      model: ViewModel(),
      builder: (BuildContext context, ViewModel vm) {
        return LoginScreen(
          connected: vm.connected,
          onLoginGoogle: vm.onLoginGoogle,
        );
      },
    );
  }
}

class ViewModel extends BaseModel<AppState> {
  ViewModel();

  ViewModel.build({
    this.connected,
    this.onLoginGoogle,
  }) : super(equals: <Object>[connected]);

  bool connected;
  VoidCallback onLoginGoogle;

  @override
  ViewModel fromStore() {
    return ViewModel.build(
      connected: state.loginState.connected,
      onLoginGoogle: () => dispatch(LoginGoogleAction()),
    );
  }
}
