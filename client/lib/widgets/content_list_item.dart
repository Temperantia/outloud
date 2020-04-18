import 'package:flutter/material.dart';

class ContentListItem extends StatelessWidget {
  const ContentListItem({this.onTap, this.leading});

  final Function onTap;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.all(10.0),
            child: Row(children: <Widget>[
              if (leading != null) leading,
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[])))
            ])));
  }
}
