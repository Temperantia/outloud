import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class SnippetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(child: Container());
    });
  }
}