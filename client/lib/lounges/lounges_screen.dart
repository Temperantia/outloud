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
  LoungesScreen(this.event);
  final Event event;
  static const String id = 'LoungesScreen';

  Widget _buildLounge(Lounge lounge) {
    User owner =
        lounge.members.firstWhere((User member) => member.id == lounge.owner);
    int availableSlots = lounge.memberLimit - lounge.members.length;
    return Row(
      children: <Widget>[
        CircularImage(
          imageUrl: owner.pics[0],
          imageRadius: 40.0,
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(lounge.name),
                GestureDetector(
                  child: Text('> JOIN'),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('$availableSlots slots available'),
                for (User member in lounge.members)
                  if (member.id != lounge.owner)
                    CircularImage(imageRadius: 20.0, imageUrl: member.pics[0]),
                for (int index = 0; index < availableSlots; index++)
                  Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(180))),
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      List<Lounge> lounges = state.userState.eventLounges[event.id];
      return View(
          title: 'BROWSING LOUNGES',
          child: Column(
            children: <Widget>[
              Text('FOR THE EVENT'),
              Row(
                children: <Widget>[
                  if (event.pic.isNotEmpty)
                    Expanded(
                        child: CachedImage(
                      event.pic,
                    )),
                  Text(event.name),
                ],
              ),
              Divider(),
              Expanded(
                  child: ListView.builder(
                itemCount: lounges.length,
                itemBuilder: (context, index) => _buildLounge(lounges[index]),
              )),
            ],
          ));
    });
  }
}
