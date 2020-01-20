import 'package:flutter/material.dart';
import 'package:inclusive/classes/interest.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/Search/search_interest.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ProfileInterests extends StatefulWidget {
  const ProfileInterests(this.user);
  final User user;
  @override
  _ProfileInterests createState() => _ProfileInterests();
}

class _ProfileInterests extends State<ProfileInterests>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> data = <Map<String, String>>[
    <String, String>{'name': 'gay community'},
    <String, String>{'name': 'cookies'},
    <String, String>{'name': 'body painting'},
  ];
  final List<TextEditingController> _controllersLeft =
      <TextEditingController>[];
  final List<TextEditingController> _controllersRight =
      <TextEditingController>[];

  final List<FocusNode> _focusLeft = <FocusNode>[];
  final List<FocusNode> _focusRight = <FocusNode>[];

  @override
  void initState() {
    super.initState();

    for (final Interest interest in widget.user.interests) {
      _addControllers(name: interest.name, comment: interest.comment);
    }
    _addControllers();
  }

  @override
  void dispose() {
    super.dispose();

    int index;
    for (index = 0; index < widget.user.interests.length; index++) {
      _removeControllers(index);
    }
    _removeControllers(index);
  }

  void _addControllers({String name = '', String comment = ''}) {
    _controllersLeft.add(TextEditingController(text: name));
    _controllersRight.add(TextEditingController(text: comment));
    final FocusNode focusLeft = FocusNode();
    focusLeft.addListener(() {
      setState(() {});
    });
    focusLeft.unfocus();
    _focusLeft.add(focusLeft);
    final FocusNode focusRight = FocusNode();
    focusRight.addListener(() {
      setState(() {});
    });
    focusRight.unfocus();
    _focusRight.add(focusRight);
  }

  void _removeControllers(int index) {
    _controllersLeft.removeAt(index);
    _controllersRight.removeAt(index);
    _focusLeft.removeAt(index);
    _focusRight.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.user.interests.length + 1,
        itemBuilder: (BuildContext context, int index) =>
            Row(children: <Widget>[
              Flexible(
                  flex: _focusLeft[index].hasFocus ? 5 : 2,
                  child: TypeAheadField<Map<String, String>>(
                      autoFlipDirection: true,
                      textFieldConfiguration: TextFieldConfiguration<String>(
                          autofocus: index == widget.user.interests.length,
                          onChanged: (dynamic value) {
                            setState(() {
                              if (value == '') {
                                widget.user.interests.removeAt(index);
                                _removeControllers(index);
                              }
                            });
                          },
                          focusNode: _focusLeft[index],
                          controller: _controllersLeft[index],
                          decoration: InputDecoration(
                              hintText: 'Your interest',
                              focusColor: orange,
                              border: const OutlineInputBorder())),
                      suggestionsCallback: (String pattern) async {
                        return data
                            .where((Map<String, String> elem) =>
                                elem['name'].startsWith(pattern))
                            .toList();
                      },
                      itemBuilder: (BuildContext context,
                          Map<String, String> suggestion) {
                        return ListTile(
                          leading: Icon(Icons.category),
                          title: Text(suggestion['name'],
                              style: TextStyle(color: Colors.black)),
                        );
                      },
                      onSuggestionSelected: (Map<String, String> suggestion) {
                        setState(() {
                          _controllersLeft[index].text = suggestion['name'];
                          _focusRight[index].requestFocus();
                        });
                      })),
              Flexible(
                  flex: _focusRight[index].hasFocus ? 5 : 3,
                  child: TextField(
                      enabled: _controllersLeft[index].text != '',
                      onChanged: (String value) => setState(() {}),
                      focusNode: _focusRight[index],
                      controller: _controllersRight[index],
                      decoration: InputDecoration(
                          hintText: 'Say something about it',
                          focusColor: orange,
                          border: const OutlineInputBorder()))),
              if (index == widget.user.interests.length &&
                  _controllersLeft[index].text != '')
                GestureDetector(
                    onTap: () {
                      print(widget.user.interests.length);

                      setState(() {
                        widget.user.interests.add(Interest(
                            name: _controllersLeft[index].text.trim(),
                            comment: _controllersRight[index].text.trim()));
                        _addControllers();
                      });
                    },
                    child: Icon(Icons.add)),
              if (index < widget.user.interests.length &&
                  (widget.user.interests[index].name !=
                          _controllersLeft[index].text ||
                      widget.user.interests[index].comment !=
                          _controllersRight[index].text))
                GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.user.interests[index].name =
                            _controllersLeft[index].text;
                        widget.user.interests[index].comment =
                            _controllersRight[index].text;
                      });
                    },
                    child: Icon(Icons.edit)),
              if (index < widget.user.interests.length)
                GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.user.interests.removeAt(index);
                        _removeControllers(index);
                      });
                    },
                    child: Icon(Icons.close))
            ]));
  }
}
