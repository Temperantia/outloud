// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:inclusive/theme.dart';

class SearchInterest extends StatefulWidget {
  final Function onUpdate;

  SearchInterest({this.onUpdate});

  @override
  SearchInterestState createState() {
    return SearchInterestState();
  }
}

class SearchInterestState extends State<SearchInterest> {
  List interests = [Item(title: 'gay')];
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: TypeAheadField(
        suggestionsCallback: (pattern) {
          List data = [{'name': 'gay'}, {'name': 'lesbian'}];
          data = data.where((var elem) => elem['name'].startsWith(pattern)).toList();
          return data;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(Icons.category),
            title: Text(suggestion['name'], style: TextStyle(color: orange)),
          );
        },
        onSuggestionSelected: (suggestion) {
          interests.add(Item(index: _count, title: suggestion['name']));
          ++_count;
        },
      )),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: blue,
        ),
        padding: const EdgeInsets.all(20),
        child: Tags(
          itemBuilder: (int index) {
            final Item item = interests[index];

            return ItemTags(
              activeColor: orange,
              key: Key(index.toString()),
              index: index,
              onRemoved: () {
                setState(() => interests.removeAt(index));
                widget.onUpdate(interests);
              },
              pressEnabled: false,
              removeButton: ItemTagsRemoveButton(
                color: orange,
                backgroundColor: white,
              ),
              title: item.title,
              textStyle: Theme.of(context).textTheme.caption,
            );
          },
          itemCount: interests
              .length, /*
            textField: TagsTextField(
              autofocus: false,
              helperTextStyle: Theme.of(context).textTheme.caption,
              hintText: '+ Add an interest',
              hintTextColor: white,
              onSubmitted: (String str) {
                setState(() {
                  interests.add(Item(index: _count, title: str));
                  ++_count;
                  widget.onUpdate(interests);
                });
              },
              //suggestions: const ['gay', 'lesbian', 'gay community'],
              //suggestionTextColor: orange,
            ),*/
        ),
      )
    ]);
  }
}
