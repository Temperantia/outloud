import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search-interest.dart';

class SearchSolo extends StatefulWidget {
  @override
  SearchSoloState createState() {
    return SearchSoloState();
  }
}

class SearchSoloState extends State<SearchSolo> {
  RangeValues _ages = RangeValues(25, 60);
  double _distance = 0;
  bool _homeland = true;
  List interests = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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
          },
        ),
        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  if (!_homeland) {
                    _homeland = true;
                  }
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: _homeland ? orange : blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Homeland',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  if (_homeland) {
                    _homeland = false;
                  }
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: _homeland ? blue : orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Overseas',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
            ],
          ),
          _homeland
              ? Slider(
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
                  },
                )
              : Container(),
        ]),
        RaisedButton(
          onPressed: () {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Processing Data'),
              ),
            );
            print(_distance.toString());
            print(_homeland.toString());
            print(interests.toString());
            print(_ages.toString());
          },
          child: Text(
            'Look for someone',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}
