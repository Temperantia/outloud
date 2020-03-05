import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/events/actions/events_get_action.dart';
import 'package:business/events/actions/events_select_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/events/event_screen.dart';
import 'package:inclusive/lounges/lounge_create_screen.dart';
import 'package:inclusive/lounges/lounge_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungesWidget extends StatefulWidget {
  @override
  _LoungesWidgetState createState() => _LoungesWidgetState();
}

class _LoungesWidgetState extends State<LoungesWidget>
    with AutomaticKeepAliveClientMixin<LoungesWidget> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildLounge(Lounge lounge,
      void Function(redux.ReduxAction<AppState>) dispatch, ThemeStyle theme) {
    return GestureDetector(
        onTap: () {
          dispatch(redux.NavigateAction<AppState>.pushNamed(LoungeScreen.id,
              arguments: lounge));
        },
        child: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              if (lounge.event.pic.isNotEmpty)
                Flexible(
                    child: CachedImage(
                  lounge.event.pic,
                )),
              Flexible(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(lounge.name, style: textStyleListItemTitle),
                            Text(lounge.description,
                                maxLines: 3, overflow: TextOverflow.ellipsis),
                          ]))),
            ])));
  }

  Widget _buildLounges(
      List<Lounge> lounges,
      void Function(redux.ReduxAction<AppState>) dispatch,
      ThemeStyle themeStyle) {
    return ListView.builder(
      itemCount: lounges.length,
      itemBuilder: (context, index) => Container(
        decoration: const BoxDecoration(color: white),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLounge(lounges[index], dispatch, themeStyle)
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      final ThemeStyle themeStyle = state.theme;
      final List<Lounge> userLounges = state.userState.lounges;
      final List<Lounge> lounges = state.loungesState.lounges;
      if (lounges == null || userLounges == null) {
        return Loading();
      }

      return DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: TabBar(
                tabs: <Widget>[
                  Tab(text: 'MY LOUNGES'),
                  Tab(text: 'FIND LOUNGES'),
                ],
              )),
              Expanded(
                  flex: 6,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      _buildLounges(userLounges, dispatch, themeStyle),
                      _buildLounges(lounges, dispatch, themeStyle),
                    ],
                  )),
              Expanded(
                child: Button(
                  text: 'CREATE LOUNGE',
                  onPressed: () => dispatch(
                      redux.NavigateAction<AppState>.pushNamed(
                          LoungeCreateScreen.id)),
                ),
              )
            ],
          ));
    });
  }
}
