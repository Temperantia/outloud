import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/bubble_bar.dart';

class View extends StatelessWidget {
  const View(
      {@required this.child, this.title = '', this.actions = const <Widget>[]});
  final Widget child;
  final String title;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    final AppDataService appDataService = Provider.of<AppDataService>(context);
    final MessageService messageService = Provider.of<MessageService>(context);
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(title, style: Theme.of(context).textTheme.caption),
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.keyboard_arrow_left, color: white)),
            actions: actions),
        bottomNavigationBar: BubbleBottomBar(
            opacity: 1.0,
            currentIndex: appDataService.currentPage,
            onTap: (int index) => appDataService.navigateBack(context, index),
            items: bubbleBar(context, messageService.pings)),
        body: SafeArea(child: child));
  }
}
