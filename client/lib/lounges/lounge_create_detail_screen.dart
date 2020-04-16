import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/lounges/actions/lounge_create_detail_action.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/lounges/lounge_create_meetup_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeCreateDetailScreen extends StatefulWidget {
  static const String id = 'LoungeCreateDetailScreen';

  @override
  _LoungeCreateDetailScreenState createState() =>
      _LoungeCreateDetailScreenState();
}

class _LoungeCreateDetailScreenState extends State<LoungeCreateDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _descriptionController = TextEditingController();

  LoungeVisibility _visibility = LoungeVisibility.Public;
  double _limit = 2;

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildLoungeVisibility(AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: AutoSizeText(
                  FlutterI18n.translate(
                      context, 'LOUNGE_CREATE_DETAIL.LOUNGE_VISIBILITY'),
                  style: const TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          Row(children: <Widget>[
            Radio<LoungeVisibility>(
              activeColor: primary(state.theme),
              groupValue: _visibility,
              value: LoungeVisibility.Public,
              onChanged: (LoungeVisibility visibility) =>
                  _visibility = visibility,
            ),
            AutoSizeText(
                FlutterI18n.translate(context, 'LOUNGE_CREATE_DETAIL.PUBLIC'),
                style: textStyleCardTitle(state.theme))
          ])
        ]));
  }

  Widget _buildLoungeMaxMemberCount(AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: AutoSizeText(
                  FlutterI18n.translate(
                      context, 'LOUNGE_CREATE_DETAIL.MAX_MEMBER_COUNT'),
                  style: const TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          Stack(alignment: Alignment.center, children: <Widget>[
            Container(
                width: 400.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: orangeLight,
                    borderRadius: BorderRadius.circular(180.0))),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          for (int memberCount = 2;
                              memberCount <= 5;
                              memberCount++)
                            if (memberCount == _limit)
                              Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: orangeAlt,
                                            borderRadius:
                                                BorderRadius.circular(180.0)),
                                        child: Center(
                                            child: AutoSizeText(
                                          memberCount.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                    Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: pinkLight.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(180.0)))
                                  ])
                            else
                              GestureDetector(
                                  onTap: () => setState(
                                      () => _limit = memberCount.toDouble()),
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: orangeAlt,
                                          borderRadius:
                                              BorderRadius.circular(180.0)),
                                      child: Center(
                                          child: AutoSizeText(
                                              memberCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: white,
                                                  fontWeight:
                                                      FontWeight.bold)))))
                        ])))
          ])
        ]));
  }

  Widget _buildLoungeUpgradeSection(AppState state) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        color: pinkLight.withOpacity(0.5),
        child: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                  FlutterI18n.translate(
                      context, 'LOUNGE_CREATE_DETAIL.PREMIUM_UPGRADE'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: pinkBright,
                      fontSize: 16,
                      fontWeight: FontWeight.w400))),
          Button(
              text: FlutterI18n.translate(
                  context, 'LOUNGE_CREATE_DETAIL.UPGRADE'),
              width: 300,
              backgroundColor: pinkBright)
        ]));
  }

  Widget _buildLoungeDescription(AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: AutoSizeText(
                  FlutterI18n.translate(
                      context, 'LOUNGE_CREATE_DETAIL.LOUNGE_DESCRIPTION'),
                  style: const TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700))),
          Container(
              constraints: BoxConstraints.expand(
                height:
                    Theme.of(context).textTheme.display1.fontSize * 1.1 + 100,
              ),
              padding: const EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
              color: whiteAlt,
              child: TextField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(color: orange),
                      border: InputBorder.none,
                      hintText: FlutterI18n.translate(
                          context, 'LOUNGE_CREATE_DETAIL.GROUP_DESCRIPTION'))))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          title: FlutterI18n.translate(
              context, 'LOUNGE_CREATE_DETAIL.CREATE_LOUNGE'),
          onBack: () => Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst),
          backIcon: Icons.close,
          buttons: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Button(
                    text: FlutterI18n.translate(
                        context, 'LOUNGE_CREATE_DETAIL.BACK'),
                    onPressed: () => dispatch(NavigateAction<AppState>.pop()),
                    paddingRight: 5),
                Button(
                    text: FlutterI18n.translate(
                        context, 'LOUNGE_CREATE_DETAIL.NEXT'),
                    onPressed: () {
                      dispatch(LoungeCreateDetailAction(_visibility,
                          _limit.toInt(), _descriptionController.text));
                      dispatch(NavigateAction<AppState>.pushNamed(
                          LoungeCreateMeetupScreen.id));
                    },
                    paddingLeft: 5)
              ]),
          child: Scrollbar(
              controller: _scrollController,
              child: ListView(children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLoungeVisibility(state),
                      _buildLoungeMaxMemberCount(state),
                      _buildLoungeUpgradeSection(state),
                      _buildLoungeDescription(state)
                    ])
              ])));
    });
  }
}
