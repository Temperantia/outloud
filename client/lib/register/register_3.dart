import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/login/actions/login_info_action.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/register/register_4.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class Register3Screen extends StatefulWidget {
  static const String id = 'Register3';

  @override
  _Register3ScreenState createState() => _Register3ScreenState();
}

class _Register3ScreenState extends State<Register3Screen> {
  Map<String, List<dynamic>> _controllers;
  String _gender;
  String _orientation;

  @override
  void initState() {
    super.initState();
    _controllers = <String, List<dynamic>>{
      'LOCATION': <TextEditingController>[TextEditingController()],
      'GENDER': <dynamic>[
        _gender,
        <String>[
          '',
          'Agender',
          'Androgyne',
          'Androgynous',
          'Bigender',
          'Cis',
          'Cisgender',
          'Cis Female',
          'Cis Male',
          'Cis Man',
          'Cis Woman',
          'Cisgender Female',
          'Cisgender Male',
          'Cisgender Man',
          'Cisgender Woman',
          'Female',
          'FTM',
          'Gender Fluid',
          'Gender Nonconforming',
          'Gender Questioning',
          'Gender Variant',
          'Genderqueer',
          'Intersex',
          'Male',
          'MTF',
          'Neither',
          'Neutrois',
          'Non-binary',
          'Other',
          'Pangender',
          'Trans',
          'Trans Female',
          'Trans Male',
          'Trans Man',
          'Trans Person',
          'Trans Woman',
          'Transfeminine',
          'Transgender',
          'Transgender Female',
          'Transgender Male',
          'Transgender Man',
          'Transgender Person',
          'Transgender Woman',
          'Transmasculine',
          'Transsexual',
          'Transsexual Female',
          'Transsexual Male',
          'Transsexual Man',
          'Transsexual Person',
          'Transsexual Woman',
          'Two-Spirit'
        ]
      ],
      'PRONOUNS': <TextEditingController>[TextEditingController()],
      'SEXUAL ORIENTATION': <dynamic>[
        _orientation,
        <String>[
          '',
          'Gay',
          'Lesbian',
          'Bi (Bisexual)',
          'Pan (Pansexual)',
          'Queer',
          'Asexual',
          'Allosexual',
          'Aromantic',
          'Heterosexual',
          'Closeted',
          'Androsexual',
          'Bicurious',
          'Demiromantic',
          'Demisexual',
          'Gynesexual',
          'Polyamorous',
          'Skoliosexual',
          'Graysexual',
          'Sapiosexual'
        ]
      ],
      'EDUCATION': <TextEditingController>[
        TextEditingController(),
        TextEditingController()
      ],
      'OCCUPATION': <TextEditingController>[
        TextEditingController(),
        TextEditingController()
      ]
    };
  }

  @override
  void dispose() {
    for (final MapEntry<String, List<dynamic>> entry in _controllers.entries) {
      if (entry is List<TextEditingController>)
        for (final TextEditingController textEditingController
            in entry.value as List<TextEditingController>) {
          textEditingController.dispose();
        }
    }
    super.dispose();
  }

  Widget _buildAboutBloc(String title, {List<String> placeholders}) =>
      Row(children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  _buildAboutController(title, _controllers[title],
                      placeholders: placeholders)
                ]))
      ]);

  Widget _buildAboutController(String title, dynamic controller,
          {List<String> placeholders}) =>
      Column(children: <Widget>[
        if (controller is List<TextEditingController>)
          for (final MapEntry<int, TextEditingController> textEditingController
              in controller.asMap().entries)
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(border: Border.all(color: orange)),
                width: 350.0, // TODO(robin): change this to expanded if you can
                height: 40.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 300.0,
                          child: TextField(
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: placeholders == null
                                      ? null
                                      : placeholders[textEditingController.key],
                                  hintStyle: const TextStyle(color: orange)),
                              controller: textEditingController.value,
                              style: const TextStyle(color: orange))),
                      if (textEditingController.value.text.isNotEmpty)
                        GestureDetector(
                            onTap: () => textEditingController.value.clear(),
                            child: Icon(Icons.close, color: orange)),
                    ]))
        else if (controller is List<dynamic>)
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(border: Border.all(color: orange)),
              width: 350.0, // TODO(robin): change this to expanded if you can
              height: 40.0,
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller[0] as String,
                  icon: const Icon(Icons.arrow_drop_down, color: orange),
                  underline: Container(),
                  style: const TextStyle(color: orange),
                  onChanged: (String newValue) =>
                      setState(() => controller[0] = newValue),
                  items: (controller[1] as List<String>)
                      .map<DropdownMenuItem<String>>((String value) =>
                          DropdownMenuItem<String>(
                              value: value, child: Text(value)))
                      .toList()))
      ]);

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<dynamic>) dispatch,
        Widget child) {
      User user = state.loginState.user;
      return View(
          showAppBar: false,
          showNavBar: false,
          child: Stack(children: <Widget>[
            Container(
                decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(colors: <Color>[pinkLight, pink]))),
            Container(
                height: MediaQuery.of(context).size.height * 5 / 6,
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)))),
            Container(
                constraints: const BoxConstraints.expand(),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(child: Container()),
                        Expanded(
                            child: Container(
                                width: 50.0,
                                height: 50.0,
                                child: Image.asset('images/OL-draft2a.png'))),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () {
                                      dispatch(LoginInfoAction(user));

                                      dispatch(
                                          NavigateAction<AppState>.pushNamed(
                                              Register4Screen.id));
                                    },
                                    child: const Text('Skip >',
                                        style: TextStyle(color: grey)))))
                      ]),
                      Expanded(
                          flex: 7,
                          child: ListView(children: <Widget>[
                            const Text('Say a little about yourself',
                                style: TextStyle(fontSize: 20.0)),
                            const Text(
                                'Let your soon-to-be friends get to know you a little better.',
                                style: TextStyle(color: grey)),
                            _buildAboutBloc('LOCATION'),
                            _buildAboutBloc('GENDER'),
                            _buildAboutBloc('PRONOUNS'),
                            _buildAboutBloc('SEXUAL ORIENTATION'),
                            _buildAboutBloc('EDUCATION',
                                placeholders: <String>['School', 'Degree']),
                            _buildAboutBloc('OCCUPATION',
                                placeholders: <String>['Position', 'Employer']),
                          ])),
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                            Button(
                                text: 'BACK',
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () =>
                                    dispatch(NavigateAction<AppState>.pop())),
                            Button(
                                text: 'NEXT',
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () {
                                  user = state.loginState.user
                                    ..home = (_controllers['LOCATION'][0]
                                            as TextEditingController)
                                        .text
                                        .trim()
                                    ..gender =
                                        _controllers['GENDER'][0] as String
                                    ..pronoun = (_controllers['PRONOUNS'][0]
                                            as TextEditingController)
                                        .text
                                        .trim()
                                    ..orientation = _controllers['SEXUAL ORIENTATION']
                                        [0] as String
                                    ..school = (_controllers['EDUCATION'][0]
                                            as TextEditingController)
                                        .text
                                        .trim()
                                    ..degree = (_controllers['EDUCATION'][1]
                                            as TextEditingController)
                                        .text
                                        .trim()
                                    ..position = (_controllers['OCCUPATION'][0]
                                            as TextEditingController)
                                        .text
                                        .trim()
                                    ..employer = (_controllers['OCCUPATION'][1] as TextEditingController).text.trim();

                                  dispatch(LoginInfoAction(user));
                                  dispatch(NavigateAction<AppState>.pushNamed(
                                      Register4Screen.id));
                                })
                          ]))
                    ])))
          ]));
    });
  }
}
