import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:business/user/actions/user_accept_eula_action.dart';

import 'package:outloud/theme.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EulaWidget extends StatelessWidget {
  final String textEnglish =
      '''This End-User License Agreement ("EULA") is a legal agreement between you and Alexandre Du Lorier 

This EULA agreement governs your acquisition and use of our OutLoud software ("Software") directly from Alexandre Du Lorier or indirectly through a Alexandre Du Lorier authorized reseller or distributor (a "Reseller").

Please read this EULA agreement carefully before completing the installation process and using the OutLoud software. It provides a license to use the OutLoud software and contains warranty information and liability disclaimers.

If you register for a free trial of the OutLoud software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the OutLoud software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.

If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.

This EULA agreement shall apply only to the Software supplied by Alexandre Du Lorier herewith regardless of whether other software is referred to or described herein. The terms also apply to any Alexandre Du Lorier updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for OutLoud.
License Grant

Alexandre Du Lorier hereby grants you a personal, non-transferable, non-exclusive licence to use the OutLoud software on your devices in accordance with the terms of this EULA agreement.

You are permitted to load the OutLoud software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the OutLoud software.

You are not permitted to:

    Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things
    Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose
    Allow any third party to use the Software on behalf of or for the benefit of any third party
    Use the Software in any way which breaches any applicable local, national or international law
    use the Software for any purpose that Alexandre Du Lorier considers is a breach of this EULA agreement

Intellectual Property and Ownership

Alexandre Du Lorier shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Alexandre Du Lorier.

Alexandre Du Lorier reserves the right to grant licences to use the Software to third parties.
Termination

This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to Alexandre Du Lorier.

It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.
Governing Law

This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of fr.
''';

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(
        builder: (BuildContext context, Store<AppState> store, AppState state,
                void Function(ReduxAction<dynamic>) dispatch, Widget child) =>
            Scaffold(
                body: Center(
                    child: Dialog(
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        child: Stack(children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.0,
                                        offset: const Offset(0.0, 10.0))
                                  ]),
                              child: SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                const Text(
                                    'This End-User License Agreement ("EULA") is a legal agreement between you and Alexandre Du Lorier',
                                    style: TextStyle(
                                        color: orange,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 15),
                                Text(textEnglish,
                                    style: const TextStyle(
                                        color: orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(
                                    child: Container(
                                        color: orange,
                                        child: Column(children: <Widget>[
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: FlatButton(
                                                      color: white,
                                                      onPressed: () {
                                                        SystemChannels.platform
                                                            .invokeMethod(
                                                                'SystemNavigator.pop');
                                                      },
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20),
                                                          child: const Text(
                                                              'DECLINE THESE TERMS',
                                                              style: TextStyle(
                                                                  color: orange,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)))))),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5, top: 5),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: FlatButton(
                                                      onPressed: () async {
                                                        store.dispatch(
                                                            UserAcceptEulaAction());
                                                      },
                                                      child: const Text(
                                                          'ACCEPT',
                                                          style: TextStyle(
                                                              color: white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)))))
                                        ])))
                              ])))
                        ])))));
  }
}
