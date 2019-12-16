import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';

import 'package:inclusive/screens/app.dart';
import 'package:inclusive/services/search.dart';
import 'package:inclusive/services/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/utils/common.dart';

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
  List _interests = [];
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: orange,
          ),
          padding: const EdgeInsets.all(20),
          child: Tags(
            itemBuilder: (int index) {
              final item = _interests[index];

              return ItemTags(
                activeColor: blue,
                key: Key(index.toString()),
                index: index,
                onRemoved: () {
                  setState(() {
                    _interests.removeAt(index);
                  });
                },
                pressEnabled: false,
                removeButton: ItemTagsRemoveButton(
                  color: blue,
                  backgroundColor: white,
                ),
                title: item.title,
                textStyle: Theme.of(context).textTheme.caption,
              );
            },
            itemCount: _interests.length,
            textField: TagsTextFiled(
              autofocus: false,
              helperTextStyle: Theme.of(context).textTheme.caption,
              hintText: '+ Add an interest',
              hintTextColor: white,
              onSubmitted: (String str) {
                setState(() {
                  _interests.add(Item(index: _count, title: str));
                  ++_count;
                });
              },
              suggestions: const ['gay', 'lesbian', 'gay community'],
              suggestionTextColor: blue,
            ),
          ),
        ),
        RangeSlider(
          labels: RangeLabels(
            _ages.start.toInt().toString() + 'y',
            _ages.end.toInt().toString() + 'y',
          ),
          min: 18,
          max: 99,
          activeColor: blue,
          inactiveColor: blueLight,
          values: _ages,
          divisions: 81,
          onChanged: (RangeValues values) {
            setState(() {
              _ages = values;
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
                  onTap: () => setState(() {
                    if (!_homeland) {
                      _homeland = true;
                    }
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _homeland ? blue : orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Homeland',
                      style: Theme.of(context).textTheme.title,
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
                      color: _homeland ? orange : blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(20),
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
                : emptyWidget,
          ],
        ),
        RaisedButton(
          onPressed: () {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Processing Data'),
              ),
            );
            debugPrint(_distance.toString());
            debugPrint(_homeland.toString());
            debugPrint(_interests.toString());
            debugPrint(_ages.toString());
            Navigator.of(context).pushNamed(
              AppScreen.routeName,
              arguments: AppScreenArguments(
                searchResults: [
                  User(
                    birthDate: DateTime.parse('1969-07-20 20:18:04Z'),
                    email: 'adulorier@gmail.com',
                    name: 'Alexandre Du lorier',
                    username: 'temp',
                  ),
                  User(
                    birthDate: DateTime.parse('1969-07-20 20:18:04Z'),
                    email: 'adulorier@gmail.com',
                    name: 'Alexandre Du lorier',
                    username: 'temp',
                  ),
                ],
              ),
            );
          },
          child: Text(
            'Look for someone',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ],
    );
  }
}
