import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/login_google_action.dart';
import 'package:business/login/actions/login_facebook_action.dart';
import 'package:business/login/actions/login_phone_action.dart';
import 'package:business/user/actions/user_listen_stream_action.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:inclusive/home_screen.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:inclusive/widgets/view.dart';

import 'package:provider_for_redux/provider_for_redux.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'Login';
  final TextEditingController _controllerPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CountryCode selectedCountry = CountryCode(code: 'FR', dialCode: '+33');
    print('build login');

    return ReduxConsumer<AppState>(
        builder: (BuildContext context, Store<AppState> store, AppState state,
                void Function(ReduxAction<dynamic>) dispatch, Widget child) =>
            View(
                showAppBar: false,
                showNavBar: false,
                child: Container(
                    decoration: background,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                  flex: 1,
                                  child: CountryCodePicker(
                                    onChanged: (CountryCode country) =>
                                        selectedCountry = country,
                                    initialSelection: selectedCountry.code,
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Phone'),
                                    controller: _controllerPhone,
                                  )),
                              Flexible(
                                  flex: 1,
                                  child: GestureDetector(
                                      onTap: () => dispatch(LoginPhoneAction(
                                          selectedCountry.dialCode +
                                              _controllerPhone.text,
                                          context)),
                                      child: Icon(Icons.phone))),
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 300.0,
                                  child: GoogleSignInButton(
                                      borderRadius: 50.0,
                                      darkMode: true,
                                      onPressed: () {
                                        dispatch(LoginGoogleAction());
                                        dispatch(UserListenStreamAction(
                                            state.loginState.id));
                                      })),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 300.0,
                                  child: FacebookSignInButton(
                                      borderRadius: 50.0,
                                      onPressed: () {
                                        dispatch(LoginFacebookAction());
                                        dispatch(UserListenStreamAction(
                                            state.loginState.id));
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      })),
                            ],
                          ),
                          Text(state.loginState.loginError),
                        ]))));
  }
}
