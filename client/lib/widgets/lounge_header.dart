import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';

class LoungeHeader extends StatelessWidget {
  const LoungeHeader({this.lounge, this.owner, this.userId});

  final Lounge lounge;
  final User owner;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (owner != null)
            Row(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  child: CachedImage(owner.pics.isEmpty ? null : owner.pics[0],
                      width: 20.0,
                      height: 20.0,
                      borderRadius: BorderRadius.circular(20.0),
                      imageType: ImageType.User)),
              Expanded(
                  child: I18nText(
                      userId == owner.id
                          ? 'LOUNGE_CHAT.YOUR_LOUNGE'
                          : 'LOUNGE_CHAT.SOMEONES_LOUNGE',
                      child: const Text('',
                          style: TextStyle(
                              color: black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      translationParams: <String, String>{'user': owner.name}))
            ]),
          Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Wrap(children: <Widget>[
                RichText(
                    text: TextSpan(
                        text:
                            '${lounge.members.length.toString()} ${FlutterI18n.translate(context, "LOUNGES_TAB.MEMBER")}${lounge.members.length > 1 ? 's ' : ' '}',
                        style: const TextStyle(
                            color: black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                      TextSpan(
                          text: lounge.event.name,
                          style: TextStyle(
                              color: orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w800))
                    ]))
              ]))
        ]);
  }
}
