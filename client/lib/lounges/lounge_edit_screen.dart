import 'package:business/classes/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:business/app_state.dart';
import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/classes/lounge.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungeEditScreen extends StatefulWidget {
  const LoungeEditScreen(this.lounge);
  final Lounge lounge;
  static const String id = 'LoungeEditScreen';

  @override
  _LoungeEditScreenState createState() => _LoungeEditScreenState(lounge);
}

class _LoungeEditScreenState extends State<LoungeEditScreen> {
  _LoungeEditScreenState(this.lounge);
  final Lounge lounge;
  final TextEditingController _descriptionController = TextEditingController();
  double _limit = 2;

  Widget _buildHeader(BuildContext context, AppState state) {
    final User owner =
        lounge.members.firstWhere((User member) => member.id == lounge.owner);
    return Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(children: <Widget>[
          if (lounge.event.pic.isNotEmpty)
            Flexible(flex: 2, child: CachedImage(lounge.event.pic)),
          Flexible(
              flex: 8,
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(children: <Widget>[
                    Container(
                        child: Row(children: <Widget>[
                      Container(
                          child: CircularImage(
                        imageUrl: owner.pics.isNotEmpty ? owner.pics[0] : null,
                        imageRadius: 30.0,
                      )),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: RichText(
                              text: TextSpan(
                            text: state.userState.user.id == owner.id
                                ? 'Your Lounge'
                                : owner.name + '\'s Lounge',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ))),
                    ])),
                    Container(
                        child: Row(children: <Widget>[
                      Container(
                          child: RichText(
                              text: TextSpan(
                                  text: lounge.members.length.toString() +
                                      ' member' +
                                      (lounge.members.length > 1 ? 's ' : ' '),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                            TextSpan(
                                text: lounge.event.name,
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ]))),
                    ])),
                  ]))),
        ]));
  }

  Widget _buildMembers(BuildContext context, AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: RichText(
                      text: const TextSpan(
                        text: 'MEMBERS',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
                    Container(
                        child: GestureDetector(
                            child: Row(
                      children: <Widget>[
                        Container(
                            child: RichText(
                          text: const TextSpan(
                            text: 'PUBLIC',
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                        Container(
                            child: IconButton(
                                iconSize: 20,
                                icon:
                                    Icon(Icons.lock_open, color: Colors.orange),
                                onPressed: null))
                      ],
                    )))
                  ],
                )),
            Container(
                child: Column(
              children: <Widget>[
                for (User member in lounge.members)
                  // if (member.id != lounge.owner)
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: <Widget>[
                                CircularImage(
                                  imageRadius: 40.0,
                                  imageUrl: member.pics.isNotEmpty
                                      ? member.pics[0]
                                      : null,
                                ),
                                Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        text: member.name,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ))
                              ],
                            )),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  child: const Button(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                backgroundColor: white,
                                text: 'KICK',
                                colorText: Colors.orange,
                                paddingRight: 10,
                                paddingLeft: 10,
                                width: 90,
                              )),
                              Container(
                                  child: const Button(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                backgroundColor: white,
                                text: 'BAN',
                                colorText: Colors.red,
                                paddingRight: 10,
                                paddingLeft: 10,
                                width: 90,
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ],
            )),
            Container(
                child: Row(
              children: <Widget>[
                Container(
                    child: IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.add_circle, color: orange),
                        onPressed: null)),
                Container(
                    child: RichText(
                  text: const TextSpan(
                    text: 'INVITE MORE PEOPLE',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ))
              ],
            ))
          ],
        ));
  }

  Widget _buildLoungeMaxMemberCount(BuildContext context, AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: RichText(
                      text: const TextSpan(
                        text: 'MAX MEMBER COUNT',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
                    Container(
                        child: const Button(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      backgroundColor: pink,
                      text: 'UPGRADE FOR MORE!',
                      colorText: Colors.black87,
                      width: 180,
                    ))
                  ],
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

  Widget _buildLoungeDescription(BuildContext context, AppState state) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1,
                ),
                child: RichText(
                  text: const TextSpan(
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
                padding:
                    const EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
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
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<dynamic>) dispatch,
        Widget child) {
      return View(
          title: 'EDIT LOUNGE',
          child: Container(
              child: Column(children: <Widget>[
            Expanded(
                child: Container(
                    color: white,
                    child: Container(
                        child: Column(children: <Widget>[
                      _buildHeader(context, state),
                      const Divider(),
                      Expanded(
                          child: Container(
                              child: Scrollbar(
                                  child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              _buildMembers(context, state),
                              _buildLoungeMaxMemberCount(context, state),
                              _buildLoungeDescription(context, state)
                            ],
                          )
                        ],
                      ))))
                    ])))),
          ])));
    });
  }
}
