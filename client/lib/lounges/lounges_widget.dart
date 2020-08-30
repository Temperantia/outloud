import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/actions/app_navigate_action.dart';
import 'package:business/actions/app_switch_events_tab.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outloud/functions/loader_animation.dart';
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
    with
        AutomaticKeepAliveClientMixin<LoungesWidget>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  void _showNoEventPopup(
      void Function(redux.ReduxAction<AppState>) dispatch,
      Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture,
      AppState state) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          )
                        ]),
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      const Icon(
                        MdiIcons.handRight,
                        color: pink,
                        size: 60,
                      ),
                      Text(
                          FlutterI18n.translate(context, 'LOUNGE_CREATE.HELLO'),
                          style: const TextStyle(
                              color: pink,
                              fontSize: 28,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 10),
                        child: Text(
                            FlutterI18n.translate(
                                context, 'LOUNGE_CREATE.NO_EVENT_WARNING'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: pink,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 15),
                        child: Text(
                            FlutterI18n.translate(
                                context, 'LOUNGE_CREATE.CONTINUE'),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                color: pink,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                          child: Container(
                              color: pink,
                              child: Column(children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                          color: white,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                  FlutterI18n.translate(context,
                                                      'LOUNGE_CREATE.STAY_IN_LOUNGES'),
                                                  style: const TextStyle(
                                                      color: pink,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)))),
                                    )),
                                Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 5),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: FlatButton(
                                            onPressed: () async {
                                              await showLoaderAnimation(
                                                  context, this,
                                                  animationDuration: 600);
                                              Navigator.pop(context);
                                              dispatch(AppNavigateAction(0));
                                              dispatch(AppSwitchEventsTab(1));
                                              // redux.NavigateAction<AppState>.pushNamed('0');
                                            },
                                            child: Text(
                                                FlutterI18n.translate(context,
                                                    'LOUNGE_CREATE.REDIRECT_TO_FIND_EVENTS'),
                                                style: const TextStyle(
                                                    color: white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)))))
                              ])))
                    ]))
              ]));
        });
  }

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
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (state.userState.events.isNotEmpty)
                          dispatch(redux.NavigateAction<AppState>.pushNamed(
                              LoungeCreateScreen.id));
                        else
                          _showNoEventPopup(
                              dispatch, store.dispatchFuture, state);
                      }),
                ]))
          ]));
    });
  }
}
