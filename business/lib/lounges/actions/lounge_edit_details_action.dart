import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:business/models/lounges.dart';

class LoungeEditDetailsAction extends ReduxAction<AppState> {
  LoungeEditDetailsAction(this.lounge, this.visibility, this.limit, this.description);

  final Lounge lounge;
  final LoungeVisibility visibility;
  final int limit;
  final String description;

  @override
  Future<AppState> reduce() async {
    lounge
      ..visibility = visibility
      ..memberLimit = limit
      ..description = description;

    await updateLounge(lounge);
    return state;
  }
}
