import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search_interest.dart';

class SearchSolo extends StatefulWidget {
  const SearchSolo({this.onSearch});

  final void Function() onSearch;

  @override
  SearchSoloState createState() {
    return SearchSoloState();
  }
}

class SearchSoloState extends State<SearchSolo> {
  RangeValues _ages = const RangeValues(25, 60);
  double _distance = 0;
  List<Item> interests = <Item>[];

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SearchInterest(),
          RangeSlider(
              labels: RangeLabels(
                _ages.start.toInt().toString() + 'y',
                _ages.end.toInt().toString() + 'y',
              ),
              min: 13,
              max: 99,
              activeColor: orange,
              inactiveColor: blueLight,
              values: _ages,
              divisions: 87,
              onChanged: (RangeValues values) {
                setState(() {
                  _ages = values;
                });
              }),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () => setState(() {
                                if (_distance == -1) {
                                  _distance = 0;
                                }
                              }),
                          child: Container(
                              decoration: BoxDecoration(
                                color: _distance == -1 ? blue : orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Near',
                                style: Theme.of(context).textTheme.caption,
                              ))),
                      GestureDetector(
                          onTap: () => setState(() {
                                if (_distance >= 0) {
                                  _distance = -1;
                                }
                              }),
                          child: Container(
                              decoration: BoxDecoration(
                                color: _distance == -1 ? orange : blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Far',
                                style: Theme.of(context).textTheme.caption,
                              )))
                    ]),
                if (_distance >= 0)
                  Slider(
                      value: _distance,
                      label: _distance.toInt().toString() + 'km',
                      min: 0,
                      max: 100,
                      activeColor: orange,
                      inactiveColor: blueLight,
                      divisions: 81,
                      onChanged: (double value) {
                        setState(() {
                          _distance = value;
                        });
                      })
              ]),
          /*  RaisedButton(
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')));
                widget.onSearch(
                    interests
                        .map<String>((Item interest) => interest.title)
                        .toList(),
                    _ages.start.toInt(),
                    _ages.end.toInt(),
                    _distance);
              },
              child: Text('Look for someone',
                  style: Theme.of(context).textTheme.caption)) */
        ]);
  }
}
