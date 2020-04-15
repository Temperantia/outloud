import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:business/login/actions/login_error_action.dart';


class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget(this.error);
  final String error;
  @override
  Widget build(BuildContext context) {
        return ReduxConsumer<AppState>(
        builder: (BuildContext context, Store<AppState> store, AppState state,
                void Function(ReduxAction<dynamic>) dispatch, Widget child) =>  AlertDialog(
            title: const Text('An error has occured' ),
            content: Text('error detail : ' + error.toString()),
            actions: <Widget>[
          FlatButton(
              child: const Text('SEND REPORT'),
              onPressed: () {
                store.dispatch(LoginErrorAction(''));
                // Navigator.pop(context);
              }),
          FlatButton(
              child: const Text('OK'),
              onPressed: () {
                store.dispatch(LoginErrorAction(''));
                // Navigator.pop(context);
              })
        ]));
  }
}
