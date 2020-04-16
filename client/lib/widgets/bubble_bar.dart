import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:business/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:outloud/theme.dart';

final Widget Function(String image, {ThemeStyle themeStyle}) _buildIcon =
    (String image, {ThemeStyle themeStyle}) =>
        Stack(alignment: Alignment.bottomLeft, children: <Widget>[
          Container(
              width: 30.0,
              height: 30.0,
              child: Image.asset(image,
                  color: themeStyle == null
                      ? white.withOpacity(0.4)
                      : white.withOpacity(0.8))),
        ]);

final BottomNavigationBarItem Function(String, ThemeStyle) _buildItem =
    (String image, ThemeStyle themeStyle) => BottomNavigationBarItem(
          icon: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: _buildIcon(image)),
          activeIcon: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: _buildIcon(image, themeStyle: themeStyle)),
          title: Container(width: 0.0, height: 0.0),
        );

final BottomNavigationBarItem Function(String, int, ThemeStyle) _buildItemWithPing =
    (String image, int pings, ThemeStyle themeStyle) => BottomNavigationBarItem(
        icon: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: pings > 0
                ? Badge(
                    position: BadgePosition.bottomLeft(),
                    badgeColor: blue,
                    badgeContent: AutoSizeText(pings.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: white, fontWeight: FontWeight.bold)),
                    child: _buildIcon(image))
                : _buildIcon(image)),
        activeIcon: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: pings > 0
                ? Badge(
                    position: BadgePosition.bottomLeft(),
                    badgeColor: blue,
                    badgeContent: AutoSizeText(pings.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: white, fontWeight: FontWeight.bold)),
                    child: _buildIcon(image, themeStyle: themeStyle))
                : _buildIcon(image, themeStyle: themeStyle)),
        title: Container(width: 0.0, height: 0.0));

final List<BottomNavigationBarItem> Function(BuildContext, int, int, ThemeStyle)
    bubbleBar =
    (BuildContext context, int pings, int loungePings, ThemeStyle themeStyle) =>
        <BottomNavigationBarItem>[
          //_buildItem('images/OL-draft1aWhite.png', themeStyle),
          _buildItem('images/iconEvent.png', themeStyle),
          _buildItemWithPing('images/iconLounge.png', loungePings, themeStyle),
          _buildItemWithPing('images/iconPeople.png', pings, themeStyle)
        ];
