import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

bool notNull(Object o) => o != null;

class SearchFormSolo extends StatefulWidget {
  @override
  SearchFormSoloState createState() {
    return SearchFormSoloState();
  }
}

class SearchFormSoloState extends State<SearchFormSolo> {
  final _formKey = GlobalKey<FormState>();
  RangeValues _values = RangeValues(25, 60);
  double _distance = 0;
  bool _homeland = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(),
          RangeSlider(
            labels: RangeLabels(
              _values.start.toInt().toString() + 'y',
              _values.end.toInt().toString() + 'y',
            ),
            min: 18,
            max: 99,
            activeColor: blue,
            inactiveColor: blueLight,
            values: _values,
            divisions: 81,
            onChanged: (RangeValues values) {
              setState(() {
                _values = values;
              });
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => setState(
                      () => {
                        if (!_homeland) {_homeland = true}
                      },
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _homeland ? blue : orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Homeland',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(
                      () => {
                        if (_homeland) {_homeland = false}
                      },
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _homeland ? orange : blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Overseas',
                        style: Theme.of(context).textTheme.title,
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
                      activeColor: blue,
                      inactiveColor: blueLight,
                      divisions: 81,
                      onChanged: (double value) {
                        setState(() {
                          _distance = value;
                        });
                      },
                    )
                  : null,
            ].where(notNull).toList(),
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Processing Data'),
                  ),
                );
              }
            },
            child: Text(
              'Find out',
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }
}
