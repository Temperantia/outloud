import 'package:async_redux/async_redux.dart' as redux;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/lounges/actions/lounge_create_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/lounges/lounge_create_detail_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeCreateScreen extends StatefulWidget {
  static const String id = 'LoungeCreateScreen';

  @override
  _LoungeCreateScreenState createState() => _LoungeCreateScreenState();
}

class _LoungeCreateScreenState extends State<LoungeCreateScreen> {
  Event _selected;

  Widget _buildUserEvent(Event event, ThemeStyle themeStyle) {
    if (event == null) {
      return Container(width: 0.0, height: 0.0);
    }
    return GestureDetector(
        onTap: () => setState(() => _selected = event),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
                color: _selected?.id == event.id
                    ? primary(themeStyle).withOpacity(0.3)
                    : null,
                borderRadius: BorderRadius.circular(5.0)),
            child: Row(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CachedImage(event.pic,
                      width: 40.0,
                      height: 40.0,
                      borderRadius: BorderRadius.circular(5.0),
                      imageType: ImageType.Event)),
              Expanded(
                  child: AutoSizeText(event.name,
                      style: const TextStyle(
                          color: orange, fontWeight: FontWeight.bold))),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      final List<Lounge> userLounges = state.userState.lounges;
      final List<Event> userEvents = state.userState.events
          .where((Event event) =>
              userLounges.firstWhere(
                  (Lounge lounge) => lounge.eventId == event.id,
                  orElse: () => null) ==
              null)
          .toList();
      return View(
          title: FlutterI18n.translate(context, 'LOUNGE_CREATE.CREATE_LOUNGE'),
          onBack: () => Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst),
          backIcon: Icons.close,
          buttons: _selected == null
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Button(
                          text: FlutterI18n.translate(
                              context, 'LOUNGE_CREATE.NEXT'),
                          width: 150.0,
                          onPressed: () {
                            dispatch(LoungeCreateAction(
                              _selected.id,
                            ));
                            dispatch(redux.NavigateAction<AppState>.pushNamed(
                                LoungeCreateDetailScreen.id));
                          }),
                    ]),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: AutoSizeText(
                          FlutterI18n.translate(
                              context, 'LOUNGE_CREATE.CHOOSE_EVENT'),
                          style: const TextStyle(fontWeight: FontWeight.w900)))
                ]),
                Expanded(
                    child: ListView.builder(
                        itemCount: userEvents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _buildUserEvent(userEvents[index], state.theme))),
              ])));
    });
  }
}
