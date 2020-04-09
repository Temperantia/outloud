import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/lounges/find_lounges.dart';
import 'package:outloud/lounges/lounge_create_screen.dart';
import 'package:outloud/lounges/my_lounges.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungesWidget extends StatefulWidget {
  @override
  _LoungesWidgetState createState() => _LoungesWidgetState();
}

class _LoungesWidgetState extends State<LoungesWidget>
    with AutomaticKeepAliveClientMixin<LoungesWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      if (state.userState.user.events == null ||
          state.userState.events == null ||
          state.userState.lounges == null) {
        return Loading();
      }

      return DefaultTabController(
          length: 2,
          child: Column(children: <Widget>[
            Expanded(
                child: TabBar(
                    labelColor: white,
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                  Tab(
                      text: FlutterI18n.translate(
                          context, 'LOUNGES_TAB.MY_LOUNGES')),
                  Tab(
                      text: FlutterI18n.translate(
                          context, 'LOUNGES_TAB.FIND_LOUNGES')),
                ])),
            Expanded(
                flex: 8,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      MyLoungesScreen(),
                      FindLoungesScreen()
                    ])),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Button(
                      text: FlutterI18n.translate(
                          context, 'LOUNGES_TAB.CREATE_LOUNGE'),
                      width: 250,
                      icon: Icon(Icons.add),
                      onPressed: () => dispatch(
                          redux.NavigateAction<AppState>.pushNamed(
                              LoungeCreateScreen.id))),
                ]))
          ]));
    });
  }
}
