import 'package:flutter/material.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/loading.dart';

class ContentList<T> extends StatelessWidget {
  const ContentList(
      {this.items,
      this.builder,
      this.withBorders = true,
      this.onRefresh,
      this.whenEmpty,
      this.reverse = false,
      this.controller});

  final List<T> items;
  final Widget Function(T) builder;
  final bool withBorders;
  final Future<void> Function() onRefresh;
  final Widget whenEmpty;
  final bool reverse;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return const Loading();
    }

    final Widget child = Scrollbar(
        child: ListView.builder(
            reverse: reverse,
            controller: controller,
            itemCount: items?.length,
            itemBuilder: (BuildContext context, int index) =>
                Column(children: <Widget>[
                  builder(items[index]),
                  if (withBorders) const Divider(color: orange),
                ])));

    return whenEmpty != null && items.isEmpty
        ? whenEmpty
        : onRefresh == null
            ? child
            : RefreshIndicator(onRefresh: () => onRefresh(), child: child);
  }
}
