import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:inclusive/theme.dart';

class SearchInterest extends StatefulWidget {
  const SearchInterest({@required this.onUpdate, this.interests});

  final List<String> Function(List<String>) onUpdate;
  final List<String> interests;

  @override
  SearchInterestState createState() {
    return SearchInterestState();
  }
}

class SearchInterestState extends State<SearchInterest> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> data = <Map<String, String>>[
    <String, String>{'name': 'gay community'},
    <String, String>{'name': 'cookies'},
    <String, String>{'name': 'body painting'},
  ];

  void _addInterest(String interest) {
    setState(() {
      _controller.clear();
      widget.interests.add(interest);
      widget.onUpdate(widget.interests);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Flexible(
            child: TypeAheadField<Map<String, String>>(
                textFieldConfiguration: TextFieldConfiguration<String>(
                    controller: _controller,
                    onEditingComplete: () {
                      if (_controller.text.isNotEmpty) {
                        _addInterest(_controller.text);
                      }
                    }),
                suggestionsCallback: (String pattern) {
                  return pattern.isEmpty
                      ? null
                      : data
                          .where((Map<String, String> elem) =>
                              elem['name'].startsWith(pattern))
                          .toList();
                },
                itemBuilder:
                    (BuildContext context, Map<String, String> suggestion) {
                  return ListTile(
                    leading: Icon(Icons.category),
                    title: Text(suggestion['name'],
                        style: TextStyle(color: orange)),
                  );
                },
                onSuggestionSelected: (Map<String, String> suggestion) =>
                    _addInterest(suggestion['name']))),
      ]),
      if (widget.interests.isNotEmpty)
        Tags(
            itemBuilder: (int index) {
              final String item = widget.interests[index];

              return ItemTags(
                  activeColor: orange,
                  color: black,
                  textColor: black,
                  textActiveColor: black,
                  key: Key(index.toString()),
                  index: index,
                  onRemoved: () {
                    setState(() {
                      widget.interests.removeAt(index);
                    });
                    widget.onUpdate(widget.interests);
                  },
                  pressEnabled: false,
                  removeButton: ItemTagsRemoveButton(
                    color: orange,
                    backgroundColor: black,
                  ),
                  title: item);
            },
            itemCount: widget.interests.length)
    ]);
  }
}
