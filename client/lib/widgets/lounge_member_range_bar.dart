import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:outloud/theme.dart';

class LoungeMemberRangeBar extends StatefulWidget {
  const LoungeMemberRangeBar({this.selected, this.max, this.onUpdate});

  final int selected;
  final int max;
  final void Function(int) onUpdate;

  @override
  _LoungeMemberRangeBarState createState() => _LoungeMemberRangeBarState();
}

class _LoungeMemberRangeBarState extends State<LoungeMemberRangeBar> {
  int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  Widget _buildMemberLimit(int memberLimit) => Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: orangeAlt, borderRadius: BorderRadius.circular(180.0)),
      child: Center(
          child: AutoSizeText(
        memberLimit.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(color: white, fontWeight: FontWeight.bold),
      )));

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.center, children: <Widget>[
        Container(
            width: 400.0,
            height: 5.0,
            decoration: BoxDecoration(
                color: orangeLight,
                borderRadius: BorderRadius.circular(180.0))),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                margin: const EdgeInsets.only(left: 50.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      for (int memberCount = 2; memberCount <= 5; memberCount++)
                        if (memberCount == _selected)
                          Stack(alignment: Alignment.center, children: <Widget>[
                            _buildMemberLimit(memberCount),
                            Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: pinkLight.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(180.0)))
                          ])
                        else
                          GestureDetector(
                              onTap: () => setState(() {
                                    _selected = memberCount;
                                    widget.onUpdate(_selected);
                                  }),
                              child: _buildMemberLimit(memberCount))
                    ])))
      ]);
}
