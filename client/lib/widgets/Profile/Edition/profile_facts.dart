import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class ProfileFacts extends StatefulWidget {
  const ProfileFacts(this.facts, {Key key}) : super(key: key);
  final List<String> facts;
  @override
  ProfileFactsState createState() =>
      ProfileFactsState(List<String>.from(facts));
}

class ProfileFactsState extends State<ProfileFacts>
    with SingleTickerProviderStateMixin {
  ProfileFactsState(this._facts);
  final List<String> _facts;

  final int _maxFacts = 10;
  final List<String> _hints = <String>[
    'I love pizza the most',
    'I prefer skiing that skating',
    'Dog over cat',
    'Scared of spiders',
    'Before I die I would like to travel at least 2/3 of the world',
    'Coffee over tea',
    'Travel is my 2nd nature',
    'Sometimes nerdy',
    'Morning shower',
    'Hate bread btw',
  ];
  final List<TextEditingController> _controllers = <TextEditingController>[];

  @override
  void initState() {
    super.initState();

    for (final String fact in _facts) {
      _addController(text: fact);
    }
    _addController();
  }

  @override
  void dispose() {
    super.dispose();

    for (final String _ in _facts) {
      _removeController();
    }
    _removeController();
  }

  List<String> onSave() {
    final List<String> facts = <String>[];
    String text;
    for (final TextEditingController controller in _controllers) {
      text = controller.text.trim();
      if (text.isNotEmpty) {
        facts.add(text);
      }
    }
    return facts;
  }

  void _addController({String text = '', int index = -1, bool focus = false}) {
    if (index == -1) {
      _controllers.add(TextEditingController(text: text));
    } else {
      _controllers.insert(index, TextEditingController(text: text));
    }
  }

  void _removeController({int index = -1}) {
    if (index == -1) {
      _controllers.removeLast();
    } else {
      _controllers.removeAt(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: const <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text('Anecdotes'))
      ]),
      ListView.builder(
          shrinkWrap: true,
          itemCount: _controllers.length,
          itemBuilder: (BuildContext context, int index) =>
              Row(children: <Widget>[
                Flexible(
                    child: TextField(
                        onChanged: (String value) {
                          setState(() {
                            if (value.isEmpty) {
                              _removeController(index: index);
                            }
                          });
                        },
                        controller: _controllers[index],
                        decoration: InputDecoration(
                            hintText: _hints[index],
                            focusColor: orange,
                            border: const OutlineInputBorder()))),
                if (_controllers.length < _maxFacts - 1 &&
                    _controllers[index].text.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _addController(index: index + 1, focus: true);
                        });
                      },
                      child: Icon(Icons.add)),
                if (index < _controllers.length - 1)
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _removeController(index: index);
                        });
                      },
                      child: Icon(Icons.close))
              ]))
    ]);
  }
}
