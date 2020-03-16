import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/cached_image.dart';
import 'package:inclusive/widgets/circular_image.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class LoungesScreen extends StatelessWidget {
  const LoungesScreen(this.event);

  final Event event;

  static const String id = 'LoungesScreen';

  Widget _buildLounge(Lounge lounge) {
    final User owner =
        lounge.members.firstWhere((User member) => member.id == lounge.owner);
    final int availableSlots = lounge.memberLimit - lounge.members.length;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: CircularImage(
                  imageUrl: owner.pics.isNotEmpty ? owner.pics[0] : null,
                  imageRadius: 40.0)),
          Expanded(
              flex: 3,
              child: Column(children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: RichText(
                              text: TextSpan(
                                  text: owner.name + '\'s Lounge',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)))),
                      GestureDetector(
                          child: Container(
                              child: RichText(
                                  text: TextSpan(
                                      text: ' > JOIN ',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700))))),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('$availableSlots slots available'),
                      Container(
                          child: Row(children: <Widget>[
                        for (User member in lounge.members)
                          if (member.id != lounge.owner)
                            CircularImage(
                                imageRadius: 20.0, imageUrl: member.pics[0]),
                        for (int index = 0; index < availableSlots; index++)
                          Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.circular(180))),
                      ])),
                    ]),
              ])),
        ]);
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1,
              ),
              child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: 'FOR THE EVENT',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)))),
          Container(
              child: Row(children: <Widget>[
            if (event.pic.isNotEmpty)
              Expanded(
                  flex: 1,
                  child: CachedImage(
                    event.pic,
                  )),
            Expanded(
                flex: 6,
                child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            text: event.name + ' | ' + event.description,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w700))))),
          ])),
        ]));
  }

  Widget _buildListLounges(List<Lounge> lounges) {
    return Container(
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 30),
            child: ListView.builder(
                itemCount: lounges.length,
                itemBuilder: (BuildContext context, int index) => Container(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildLounge(lounges[index])))));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      final List<Lounge> lounges = state.userState.eventLounges[event.id];
      return View(
          title: 'BROWSING LOUNGES',
          child: Container(
              constraints: const BoxConstraints.expand(
                  // width: MediaQuery.of(context).size.width
                  ),
              child: Column(children: <Widget>[
                Expanded(
                    child: Container(
                        color: white,
                        child: Container(
                            child: Column(children: <Widget>[
                          _buildHeader(context),
                          const Divider(),
                          Expanded(
                            child: _buildListLounges(lounges),
                          ),
                        ])))),
              ])

              // child: Column(
              //   children: <Widget>[
              //     const Text('FOR THE EVENT'),
              //     Row(
              //       children: <Widget>[
              //         if (event.pic.isNotEmpty)
              //           Expanded(
              //               flex: 1,
              //               child: CachedImage(
              //                 event.pic,
              //               )),
              //         Expanded(
              //           flex: 6,
              //           child: Text(event.name),
              //         )
              //       ],
              //     ),
              //     const Divider(),
              //     Container(
              //         // width: 600,
              //         child: Container(
              //             color: white,
              //             child: ListView.builder(
              //               itemCount: lounges.length,
              //               itemBuilder: (BuildContext context, int index) =>
              //                   _buildLounge(lounges[index]),
              //             ))),
              //   ],
              // )
              ));
    });
  }
}
