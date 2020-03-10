import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/lounges/actions/lounge_create_detail_action.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inclusive/lounges/lounge_create_meetup_screen.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/view.dart';
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

  Widget _buildLoungeVisibility(AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'LOUNGE VISIBILITY',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                )),
            Row(
              children: <Widget>[
                Radio(
                  activeColor: primary(state.theme),
                  groupValue: _visibility,
                  value: LoungeVisibility.Public,
                  onChanged: (LoungeVisibility visibility) =>
                      _visibility = visibility,
                ),
                Text('PUBLIC', style: textStyleCardTitle(state.theme))
              ],
            ),
          ],
        ));
  }

  Widget _buildLoungeMaxMemberCount(AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'MAX MEMBER COUNT',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                )),
            Slider(
                value: _limit,
                label: _limit.toInt().toString(),
                min: 2,
                max: 5,
                activeColor: orange,
                inactiveColor: orangeLight,
                divisions: 3,
                onChanged: (double value) {
                  setState(() {
                    _limit = value;
                  });
                })
          ],
        ));
  }

  Widget _buildLoungeUpgradeSection(AppState state) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
            color: pink,
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'Upgrade your lounge for more members, bigger reach, and featured spolight',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Container(
                    width: 220,
                    margin: const EdgeInsets.all(20.0),
                    child: Button(
                      text: 'UPGRADE   >',
                    ))
              ],
            ))
      ],
    ));
  }

  Widget _buildLoungeDescription(AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'LOUNGE DESCRIPTION',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                )),
            Container(
                constraints: BoxConstraints.expand(
                  height:
                      Theme.of(context).textTheme.display1.fontSize * 1.1 + 100,
                ),
                padding: const EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
                color: orangeLight,
                child: TextField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(100),
                  ],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Brief description of your group.'),
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          title: 'CREATE LOUNGE',
          onBack: () => Navigator.popUntil(
              context, (Route<dynamic> route) => route.isFirst),
          backIcon: Icons.close,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Container(
                      color: white,
                      // padding: const EdgeInsets.all(10.0),
                      child: Scrollbar(
                          controller: _scrollController,
                          child: ListView(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _buildLoungeVisibility(state),
                                  _buildLoungeMaxMemberCount(state),
                                  _buildLoungeUpgradeSection(state),
                                  _buildLoungeDescription(state)
                                ],
                              )
                            ],
                          )))),
              Expanded(
                  child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                    Container(
                        margin: const EdgeInsets.all(15.0),
                        width: 140,
                        child: Button(
                            text: 'BACK',
                            onPressed: () {
                              dispatch(NavigateAction<AppState>.pop());
                            })),
                    Container(
                        margin: const EdgeInsets.all(15.0),
                        width: 140,
                        child: Button(
                            text: 'NEXT',
                            onPressed: () {
                              dispatch(LoungeCreateDetailAction(_visibility,
                                  _limit.toInt(), _descriptionController.text));
                              dispatch(NavigateAction<AppState>.pushNamed(
                                LoungeCreateMeetupScreen.id,
                              ));
                            })),
                  ])))
            ],
          ));
    });
  }
}
