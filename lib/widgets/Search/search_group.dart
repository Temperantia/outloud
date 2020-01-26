import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';
//import 'package:inclusive/widgets/Search/search_interest.dart';

class SearchGroup extends StatefulWidget {
  @override
  SearchGroupState createState() {
    return SearchGroupState();
  }
}

class SearchGroupState extends State<SearchGroup> {
  List<dynamic> interests = <dynamic>[];
  double _groupSize = 0;
  final List<String> _groupSizeLabels = <String>[
    '- 10 users',
    '10 - 50 users',
    '+ 50 users'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //const SearchInterest(),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: blueLight,
            inactiveTickMarkColor: orange,
            inactiveTrackColor: blueLight,
            thumbColor: orange,
            valueIndicatorColor: orange,
          ),
          child: Slider(
            value: _groupSize,
            label: _groupSizeLabels[_groupSize.toInt()],
            min: 0,
            max: 2,
            divisions: 2,
            onChanged: (double value) {
              setState(() {
                _groupSize = value;
              });
            },
          ),
        ),
        RaisedButton(
          onPressed: () {
            Scaffold.of(context).showSnackBar(
              const SnackBar(
                content: Text('Processing Data'),
              ),
            );
          },
          child: Text(
            'Look for folks',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}