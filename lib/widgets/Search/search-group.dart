// Define a custom Form widget.
import 'package:flutter/material.dart';

import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search-interest.dart';

class SearchGroup extends StatefulWidget {
  @override
  SearchGroupState createState() {
    return SearchGroupState();
  }
}

class SearchGroupState extends State<SearchGroup> {
  List interests = [];
  double _groupSize = 0;
  List<String> _groupSizeLabels = const ['- 10 users', '10 - 50 users', '+ 50 users'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SearchInterest(
            onUpdate: (List interests) =>
                setState(() => this.interests = interests)),
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
              SnackBar(
                content: const Text('Processing Data'),
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
