import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/lounges/actions/lounge_remove_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/event_image.dart';
import 'package:outloud/widgets/lounge_header.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeBanner extends StatefulWidget {
  const LoungeBanner({this.lounge, this.owner, this.userId});

  final Lounge lounge;
  final User owner;
  final String userId;

  @override
  _LoungeBannerState createState() => _LoungeBannerState();
}

class _LoungeBannerState extends State<LoungeBanner>
    with TickerProviderStateMixin {
  void Function(ReduxAction<AppState>) _dispatch;

  void _showConfirmPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Dialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 10.0))
                      ]),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    const Icon(MdiIcons.trashCan, color: orange, size: 60),
                    AutoSizeText(
                        FlutterI18n.translate(
                            context, 'LOUNGE_EDIT.DELETE_LOUNGE'),
                        style: const TextStyle(
                            color: orange,
                            fontSize: 26,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: AutoSizeText(
                            FlutterI18n.translate(
                                context, 'LOUNGE_EDIT.PERMANENT_DELETE'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    Container(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 15),
                        child: AutoSizeText(
                            FlutterI18n.translate(
                                context, 'LOUNGE_EDIT.DELETE_CONFIRMATION'),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
                    SizedBox(
                        child: Container(
                            color: orange,
                            child: Column(children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                          color: white,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: AutoSizeText(
                                                  FlutterI18n.translate(context,
                                                      'LOUNGE_EDIT.TAKE_ME_BACK'),
                                                  style: const TextStyle(
                                                      color: orange,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)))))),
                              Container(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FlatButton(
                                          onPressed: () async {
                                            _dispatch(LoungeRemoveAction(
                                                widget.lounge));
                                            _dispatch(
                                                NavigateAction<AppState>.pop());
                                            _dispatch(
                                                NavigateAction<AppState>.pop());
                                            _dispatch(
                                                NavigateAction<AppState>.pop());
                                          },
                                          child: AutoSizeText(
                                              FlutterI18n.translate(context,
                                                  'LOUNGE_EDIT.DELETE_YES'),
                                              style: const TextStyle(
                                                  color: white,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w500)))))
                            ])))
                  ]))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;
      return Container(
          padding: const EdgeInsets.all(15.0),
          child: Row(children: <Widget>[
            Container(
                margin: const EdgeInsets.only(right: 5.0),
                child: EventImage(
                    image: widget.lounge.event.pic,
                    size: 50.0,
                    hasOverlay: false)),
            Expanded(
                child: LoungeHeader(
                    lounge: widget.lounge,
                    owner: widget.owner,
                    userId: widget.userId)),
            if (widget.owner.id == widget.userId)
              GestureDetector(
                  onTap: () => _showConfirmPopup(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Icon(MdiIcons.trashCan, color: orange),
                        AutoSizeText(
                            FlutterI18n.translate(
                                context, 'LOUNGE_EDIT.REMOVE'),
                            style: const TextStyle(
                                color: orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        AutoSizeText(
                            FlutterI18n.translate(
                                context, 'LOUNGE_EDIT.LOUNGE'),
                            style: const TextStyle(
                                color: orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold))
                      ]))
          ]));
    });
  }
}
