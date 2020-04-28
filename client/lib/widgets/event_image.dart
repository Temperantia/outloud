import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:intl/intl.dart';

class EventImage extends StatelessWidget {
  const EventImage(
      {this.image,
      this.state,
      this.size = 80.0,
      this.hasOverlay = true,
      this.isChat = false,
      this.dateStart,
      this.dateEnd,
      this.newMessageCount});

  final String image;
  final UserEventState state;
  final double size;
  final bool hasOverlay;
  final bool isChat;
  final DateTime dateStart;
  final DateTime dateEnd;
  final int newMessageCount;

  @override
  Widget build(BuildContext context) {
    Widget dateWidget;
    String day = '';
    String month = '';

    if (dateStart != null) {
      day = DateFormat('dd').format(dateStart);
      month = DateFormat('MMM').format(dateStart);

      if (dateEnd != null) {
        if (!Utils.isSameDay(dateStart, dateEnd)) {
          day += ' - ${DateFormat('dd').format(dateEnd)}';
        }
        if (dateStart.month != dateEnd.month) {
          month += ' - ${DateFormat('MMM').format(dateEnd)}';
        }
      }
      dateWidget = Column(children: <Widget>[
        AutoSizeText(day,
            style: const TextStyle(
                color: white, fontWeight: FontWeight.bold, fontSize: 20)),
        AutoSizeText(month,
            style: const TextStyle(color: white, fontWeight: FontWeight.bold))
      ]);
    }

    return Stack(alignment: Alignment.center, children: <Widget>[
      Container(
          decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: orange, width: 7.0))),
          child: CachedImage(image,
              width: size,
              height: size,
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)),
              imageType: ImageType.Event)),
      if (hasOverlay)
        Container(
            width: size + 7.0,
            height: size,
            decoration: BoxDecoration(
                color: pink.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(5.0),
                    topRight: Radius.circular(5.0)))),
      if (dateWidget != null) dateWidget,
      if (state == UserEventState.Attending)
        Icon(Icons.check, size: size - 20.0, color: white)
      else if (state == UserEventState.Liked)
        Icon(MdiIcons.heart, size: size - 20.0, color: white),
      if (isChat)
        Image.asset('images/chatIcon.png',
            width: size - 20.0, height: size - 20.0),
      if ((newMessageCount ?? 0) > 0)
        Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
                width: size - 20.0,
                height: size - 20.0,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: blue, borderRadius: BorderRadius.circular(60.0)),
                child: Center(
                  child: AutoSizeText(newMessageCount.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: white, fontWeight: FontWeight.bold)),
                )))
    ]);
  }
}
