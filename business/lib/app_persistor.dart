import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';

// TODO(x): move login auth mode local persistor here
class AppPersistor extends Persistor<AppState> {
  @override
  Future<AppState> readState() async {
    return AppState.initialState();
  }

  @override
  Future<void> deleteState() async {
    // TODO(x): delete everything saved
  }

  @override
  Future<void> persistDifference(
      {@required AppState lastPersistedState,
      @required AppState newState}) async {}
}
