// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';

import 'package:inclusive/theme.dart';

class SearchGroup extends StatefulWidget {
  @override
  SearchGroupState createState() {
    return SearchGroupState();
  }
}

class SearchGroupState extends State<SearchGroup> {
  List _items = [];
  int _count = 0;
  double _groupSize = 0;
  List<String> _groupSizeLabels = const ['- 10 users', '10 - 50 users', '+ 50 users'];

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
              final item = _items[index];

              return ItemTags(
                activeColor: blue,
                key: Key(index.toString()),
                index: index,
                onRemoved: () {
                  setState(() {
                    _items.removeAt(index);
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
            itemCount: _items.length,
            textField: TagsTextField(
              autofocus: false,
              helperTextStyle: Theme.of(context).textTheme.caption,
              hintText: '+ Add an interest',
              hintTextColor: white,
              onSubmitted: (String str) {
                setState(() {
                  _items.add(Item(index: _count, title: str));
                  ++_count;
                });
              },
              suggestions: const ['gay', 'lesbian', 'gay community'],
              suggestionTextColor: blue,
            ),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: blueLight,
            inactiveTickMarkColor: blue,
            inactiveTrackColor: blueLight,
            thumbColor: blue,
            valueIndicatorColor: blue,
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
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ],
    );
  }
}
