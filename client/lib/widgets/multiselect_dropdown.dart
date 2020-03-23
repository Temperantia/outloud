import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class MyMultiCheckBoxesContent extends StatefulWidget {
  const MyMultiCheckBoxesContent({
    Key key,
    this.checkboxes,
  }) : super(key: key);

  final List<CheckBoxContent> checkboxes;

  @override
  State<StatefulWidget> createState() => _MyMultiCheckBoxesContent();
}

class _MyMultiCheckBoxesContent extends State<MyMultiCheckBoxesContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 9,
            child: ListView.builder(
                itemCount: widget.checkboxes.length,
                itemBuilder: (BuildContext context, int index) => Container(
                      child: CheckboxListTile(
                          checkColor: orange,
                          title: Text(widget.checkboxes[index].name),
                          value: widget.checkboxes[index].checked,
                          onChanged: (bool choosen) {
                            setState(() {
                              widget.checkboxes[index].checked = choosen;
                            });
                          }),
                    )))
      ],
    );
  }
}

class CheckBoxContent {
  CheckBoxContent({this.name = '', this.checked = false});

  String name;
  bool checked;
}
