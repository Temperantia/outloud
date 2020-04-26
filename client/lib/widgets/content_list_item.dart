import 'package:flutter/material.dart';

class ContentListItem extends StatelessWidget {
  const ContentListItem(
      {this.onTap,
      this.leading,
      this.title,
      this.subtitle,
      this.buttons,
      this.trailing});

  final Function onTap;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget buttons;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.all(5.0),
            child: Row(children: <Widget>[
              if (leading != null) leading,
              if (title != null || subtitle != null || buttons != null)
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              if (title != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: title,
                                ),
                              if (subtitle != null)
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: subtitle),
                              if (buttons != null) buttons
                            ]))),
              if (trailing != null) trailing
            ])));
  }
}
