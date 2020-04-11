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
          title: Container(),
        );

final List<BottomNavigationBarItem> Function(BuildContext, int, ThemeStyle)
    bubbleBar = (BuildContext context, int pings, ThemeStyle themeStyle) =>
        <BottomNavigationBarItem>[
          //_buildItem('images/OL-draft1aWhite.png', themeStyle),
          _buildItem('images/iconEvent.png', themeStyle),
          _buildItem('images/iconLounge.png', themeStyle),
          BottomNavigationBarItem(
              icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: pings > 0
                      ? Badge(
                          position: BadgePosition.bottomLeft(),
                          badgeColor: blue,
                          badgeContent: Text(pings.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: white, fontWeight: FontWeight.bold)),
                          child: _buildIcon('images/iconPeople.png'))
                      : _buildIcon('images/iconPeople.png')),
              activeIcon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: pings > 0
                      ? Badge(
                          position: BadgePosition.bottomLeft(),
                          badgeColor: blue,
                          badgeContent: Text(pings.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: white, fontWeight: FontWeight.bold)),
                          child: _buildIcon('images/iconPeople.png',
                              themeStyle: themeStyle))
                      : _buildIcon('images/iconPeople.png',
                          themeStyle: themeStyle)),
              title: Container()),
        ];
