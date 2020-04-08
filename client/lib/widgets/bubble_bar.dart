import 'package:badges/badges.dart';
import 'package:business/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:outloud/theme.dart';

final Container Function(String image, {ThemeStyle themeStyle}) _buildIcon =
    (String image, {ThemeStyle themeStyle}) => Container(
        width: 30.0,
        height: 30.0,
        child: Image.asset(image,
            color: themeStyle == null
                ? white.withOpacity(0.4)
                : white.withOpacity(0.8)));

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

final List<BottomNavigationBarItem> Function(
    BuildContext, int, ThemeStyle) bubbleBar = (BuildContext context, int pings,
        ThemeStyle themeStyle) =>
    <BottomNavigationBarItem>[
      //_buildItem('images/OL-draft1aWhite.png', themeStyle),
      _buildItem('images/iconEvent.png', themeStyle),
      _buildItem('images/iconLounge.png', themeStyle),
      BottomNavigationBarItem(
        icon: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: pings > 0
                ? Badge(
                    badgeColor: pink,
                    badgeContent: Text(pings.toString()),
                    child: _buildIcon('images/iconPeople.png'))
                : _buildIcon('images/iconPeople.png')),
        activeIcon: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildIcon('images/iconPeople.png', themeStyle: themeStyle)),
        title: Container(),
      ),
    ];
