import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inclusive/classes/interest.dart';

import 'package:inclusive/theme.dart';

class SearchInterest extends StatefulWidget {
  const SearchInterest({this.onUpdate, this.interests});

  final Function onUpdate;
  final List<Interest> interests;

  @override
  SearchInterestState createState() {
    return SearchInterestState();
  }
}

class SearchInterestState extends State<SearchInterest> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TypeAheadField<Map<String, String>>(
          textFieldConfiguration:
              TextFieldConfiguration<String>(controller: _controller),
          suggestionsCallback: (String pattern) {
            List<Map<String, String>> data = <Map<String, String>>[
              <String, String>{'name': 'gay community'},
              <String, String>{'name': 'cookies'},
              <String, String>{'name': 'body painting'},
            ];
            data = data
                .where((Map<String, String> elem) =>
                    elem['name'].startsWith(pattern))
                .toList();
            return data;
          },
          itemBuilder: (BuildContext context, Map<String, String> suggestion) {
            return ListTile(
              leading: Icon(Icons.category),
              title: Text(suggestion['name'], style: TextStyle(color: orange)),
            );
          },
          onSuggestionSelected: (Map<String, String> suggestion) {
            setState(() {
              _controller.clear();
              widget.interests.add(Interest(name: suggestion['name']));
              widget.onUpdate(widget.interests);
            });
          }),
      if (widget.interests.isNotEmpty)
        Tags(
            itemBuilder: (int index) {
              final Interest item = widget.interests[index];

              return ItemTags(
                  activeColor: orange,
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
                    backgroundColor: white,
                  ),
                  title: item.name,
                  textStyle: Theme.of(context).textTheme.caption);
            },
            itemCount: widget.interests
                .length /*
            textField: TagsTextField(
              autofocus: false,
              helperTextStyle: Theme.of(context).textTheme.caption,
              hintText: '+ Add an interest',
              hintTextColor: white,
              onSubmitted: (String str) {
                setState(() {
                  widget.interests.add(Item(index: _count, title: str));
                  ++_count;
                  widget.onUpdate(widget.interests);
                });
              },
              //suggestions: const ['gay', 'lesbian', 'gay community'],
              //suggestionTextColor: orange,
            ),*/
            )
    ]);
  }
}
