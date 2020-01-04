import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search-interest.dart';

class SearchSolo extends StatefulWidget {
  SearchSolo({this.onSearch});

  final Function onSearch;

  @override
  SearchSoloState createState() {
    return SearchSoloState();
  }
}

class SearchSoloState extends State<SearchSolo> {
  RangeValues _ages = RangeValues(25, 60);
  double _distance = 0;
  List interests = [];

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SearchInterest(
          onUpdate: (List interests) =>
              setState(() => this.interests = interests)),
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
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                    'Local',
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
                    'Global',
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
      RaisedButton(
          onPressed: () {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
            widget.onSearch(
                interests
                    .map((interest) => interest.title)
                    .toList()
                    .cast<String>(),
                _ages.start.toInt(),
                _ages.end.toInt(),
                _distance);
          },
          child: Text('Look for someone',
              style: Theme.of(context).textTheme.caption))
    ]);
  }
}
