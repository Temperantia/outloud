import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:outloud/theme.dart';

class ContentList extends StatelessWidget {
  const ContentList({this.items, this.builder, this.onRefresh});

  final List<dynamic> items;
  final Widget Function(dynamic) builder;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final Widget child = items == null
        ? const CircularProgressIndicator()
        : Scrollbar(
            child: ListView.builder(
                itemCount: items?.length,
                itemBuilder: (BuildContext context, int index) =>
                    Column(children: <Widget>[
                      builder(items[index]),
                      const Divider(color: orange),
                    ])));

    return onRefresh == null
        ? child
        : RefreshIndicator(onRefresh: () => onRefresh(), child: child);
  }
}
