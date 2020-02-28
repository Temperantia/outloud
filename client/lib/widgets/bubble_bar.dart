import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';

final Widget Function(String) _buildIcon = (String image) => Container(
      width: 30.0,
      height: 30.0,
      child: Image.asset(image),
    );

final BottomNavigationBarItem Function(String) _buildItem =
    (String image) => BottomNavigationBarItem(
          icon: Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: _buildIcon(image)),
          activeIcon: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              decoration: const BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.all(Radius.circular(90.0))),
              child: _buildIcon(image)),
          title: Container(),
        );

final List<BottomNavigationBarItem> Function(BuildContext, int) bubbleBar =
    (BuildContext context, int pings) => <BottomNavigationBarItem>[
          _buildItem('images/usuario.png'),
          _buildItem('images/evento.png'),
          _buildItem('images/lista.png'),
          BottomNavigationBarItem(
            icon: Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: pings > 0
                    ? Badge(
                        badgeColor: pink,
                        badgeContent: Text(pings.toString()),
                        child: _buildIcon('images/charla.png'))
                    : _buildIcon('images/charla.png')),
            activeIcon: Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.all(Radius.circular(90.0))),
                child: _buildIcon('images/charla.png')),
            title: Container(),
          ),
        ];
