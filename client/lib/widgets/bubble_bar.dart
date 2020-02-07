import 'package:badges/badges.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';

final List<BubbleBottomBarItem> Function(
    BuildContext, int) bubbleBar = (BuildContext context,
        int pings) =>
    <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          icon: Icon(Icons.portrait, color: orange),
          activeIcon: Icon(Icons.portrait, color: white),
          backgroundColor: orange,
          title: Text('Me', style: TextStyle(color: white, fontSize: 14.0))),
      BubbleBottomBarItem(
          icon: pings > 0
              ? Badge(
                  badgeColor: orange,
                  badgeContent: Text(pings.toString()),
                  child: Icon(Icons.message, color: orange))
              : Icon(Icons.message, color: orange),
          activeIcon: Icon(Icons.message, color: white),
          backgroundColor: orange,
          title:
              Text('Message', style: TextStyle(color: white, fontSize: 14.0))),
      BubbleBottomBarItem(
          icon: Icon(Icons.view_list, color: orange),
          activeIcon: Icon(Icons.view_list, color: white),
          backgroundColor: orange,
          title:
              Text('People', style: TextStyle(color: white, fontSize: 14.0))),
      BubbleBottomBarItem(
          icon: Icon(Icons.people, color: orange),
          activeIcon: Icon(Icons.people, color: white),
          backgroundColor: orange,
          title: Text('Group', style: TextStyle(color: white, fontSize: 14.0))),
      BubbleBottomBarItem(
          icon: Icon(Icons.event, color: orange),
          activeIcon: Icon(Icons.event, color: white),
          backgroundColor: orange,
          title: Text('Event', style: TextStyle(color: white, fontSize: 14.0))),
    ];
