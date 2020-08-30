import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/login/actions/login_info_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/register/register_4.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/view.dart';
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
      'GENDER': <dynamic>[_gender],
      'PRONOUNS': <TextEditingController>[TextEditingController()],
      'SEXUAL ORIENTATION': <dynamic>[_orientation],
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
                            child: const Icon(Icons.close, color: orange)),
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
      _controllers['GENDER'].add(<String>[
        '',
        FlutterI18n.translate(context, 'GENDERS.AGENDER'),
        FlutterI18n.translate(context, 'GENDERS.ANDROGYNE'),
        FlutterI18n.translate(context, 'GENDERS.ANDROGYNOUS'),
        FlutterI18n.translate(context, 'GENDERS.BIGENDER'),
        FlutterI18n.translate(context, 'GENDERS.CIS'),
        FlutterI18n.translate(context, 'GENDERS.CISGENDER'),
        FlutterI18n.translate(context, 'GENDERS.CIS_FEMALE'),
        FlutterI18n.translate(context, 'GENDERS.CIS_MALE'),
        FlutterI18n.translate(context, 'GENDERS.CIS_MAN'),
        FlutterI18n.translate(context, 'GENDERS.CIS_WOMAN'),
        FlutterI18n.translate(context, 'GENDERS.CIS_GENDER_FEMALE'),
        FlutterI18n.translate(context, 'GENDERS.CISGENDER_MALE'),
        FlutterI18n.translate(context, 'GENDERS.CISGENDER_MAN'),
        FlutterI18n.translate(context, 'GENDERS.CISGENDER_WOMAN'),
        FlutterI18n.translate(context, 'GENDERS.FEMALE'),
        FlutterI18n.translate(context, 'GENDERS.FTM'),
        FlutterI18n.translate(context, 'GENDERS.GENDER_FLUID'),
        FlutterI18n.translate(context, 'GENDERS.GENDER_NONCONFORMING'),
        FlutterI18n.translate(context, 'GENDERS.GENDER_QUESTIONING'),
        FlutterI18n.translate(context, 'GENDERS.GENDER_VARIANT'),
        FlutterI18n.translate(context, 'GENDERS.GENDERQUEER'),
        FlutterI18n.translate(context, 'GENDERS.INTERSEX'),
        FlutterI18n.translate(context, 'GENDERS.MALE'),
        FlutterI18n.translate(context, 'GENDERS.MTF'),
        FlutterI18n.translate(context, 'GENDERS.NEITHER'),
        FlutterI18n.translate(context, 'GENDERS.NEUTROIS'),
        FlutterI18n.translate(context, 'GENDERS.NON_BINARY'),
        FlutterI18n.translate(context, 'GENDERS.OTHER'),
        FlutterI18n.translate(context, 'GENDERS.PANGENDER'),
        FlutterI18n.translate(context, 'GENDERS.TRANS'),
        FlutterI18n.translate(context, 'GENDERS.TRANS_FEMALE'),
        FlutterI18n.translate(context, 'GENDERS.TRANS_MALE'),
        FlutterI18n.translate(context, 'GENDERS.TRANS_MAN'),
        FlutterI18n.translate(context, 'GENDERS.TRANS_PERSON'),
        FlutterI18n.translate(context, 'GENDERS.TRANS_WOMAN'),
        FlutterI18n.translate(context, 'GENDERS.TRANSFEMININE'),
        FlutterI18n.translate(context, 'GENDERS.TRANSGENDER'),
        FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_FEMALE'),
        FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_MALE'),
        FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_MAN'),
        FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_PERSON'),
        FlutterI18n.translate(context, 'GENDERS.TRANSGENDER_WOMAN'),
        FlutterI18n.translate(context, 'GENDERS.TRANSMASCULINE'),
        FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL'),
        FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_FEMALE'),
        FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_MALE'),
        FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_MAN'),
        FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_PERSON'),
        FlutterI18n.translate(context, 'GENDERS.TRANSSEXUAL_WOMAN'),
        FlutterI18n.translate(context, 'GENDERS.TWO_SPIRIT'),
      ]);

      _controllers['SEXUAL ORIENTATION'].add(<String>[
        '',
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.GAY'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.LESBIAN'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.BI'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.PAN'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.QUEER'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.ASEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.ALLOSEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.AROMANTIC'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.HETEROSEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.CLOSETED'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.ANDROSEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.BICURIOUS'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.DEMIROMANTIC'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.DEMISEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.GYNESEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.POLYAMOROUS'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.SKOLIOSEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.GRAYSEXUAL'),
        FlutterI18n.translate(context, 'SEXUAL_ORIENTATIONS.SAPIOSEXUAL'),
      ]);
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
                                    child: Text(
                                        FlutterI18n.translate(
                                            context, 'REGISTER_3.SKIP'),
                                        style: const TextStyle(color: grey)))))
                      ]),
                      Expanded(
                          flex: 7,
                          child: ListView(children: <Widget>[
                            Text(
                                FlutterI18n.translate(
                                    context, 'REGISTER_3.TITLE'),
                                style: const TextStyle(fontSize: 20.0)),
                            Text(
                                FlutterI18n.translate(
                                    context, 'REGISTER_3.SUBTITLE'),
                                style: const TextStyle(color: grey)),
                            _buildAboutBloc(FlutterI18n.translate(
                                context, 'REGISTER_3.LOCATION')),
                            _buildAboutBloc(FlutterI18n.translate(
                                context, 'REGISTER_3.GENDER')),
                            _buildAboutBloc(FlutterI18n.translate(
                                context, 'REGISTER_3.PRONOUNS')),
                            _buildAboutBloc(FlutterI18n.translate(
                                context, 'REGISTER_3.SEXUAL_ORIENTATION')),
                            _buildAboutBloc(
                                FlutterI18n.translate(
                                    context, 'REGISTER_3.EDUCATION'),
                                placeholders: <String>[
                                  FlutterI18n.translate(
                                      context, 'REGISTER_3.SCHOOL'),
                                  FlutterI18n.translate(
                                      context, 'REGISTER_3.DEGREE')
                                ]),
                            _buildAboutBloc(
                                FlutterI18n.translate(
                                    context, 'REGISTER_3.OCCUPATION'),
                                placeholders: <String>[
                                  FlutterI18n.translate(
                                      context, 'REGISTER_3.POSITION'),
                                  FlutterI18n.translate(
                                      context, 'REGISTER_3.EMPLOYER')
                                ]),
                          ])),
                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_3.BACK'),
                                width: MediaQuery.of(context).size.width * 0.4,
                                onPressed: () =>
                                    dispatch(NavigateAction<AppState>.pop())),
                            Button(
                                text: FlutterI18n.translate(
                                    context, 'REGISTER_3.NEXT'),
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
