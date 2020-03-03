import 'dart:typed_data';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/button.dart';
import 'package:inclusive/widgets/view.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class EventCreateScreen extends StatefulWidget {
  static const String id = 'EventCreate';

  @override
  _EventCreateScreenState createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  var name = TextEditingController();
  Uint8List _picture;
  var description = TextEditingController();

  Future<void> onSave(
      void Function(redux.ReduxAction<AppState>) dispatch) async {
    final Event event = await createEvent()
      ..name = name.text
      ..description = description.text
      ..date = DateTime.now();
    //final String url = await saveImage(_picture, event.id);
    //event..pic = url;
    updateEvent(event);
    dispatch(redux.NavigateAction<AppState>.pop());
  }

  Future<String> saveImage(Uint8List image, String eventId) async {
    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('images/events/$eventId/${DateTime.now()}');
    final StorageUploadTask uploadTask = ref.putData(image);
    final StorageTaskSnapshot result = await uploadTask.onComplete;
    return (await result.ref.getDownloadURL()).toString();
  }

  Future<void> deleteImage(String url, String eventId) async {
    (await FirebaseStorage.instance.getReferenceFromUrl(url)).delete();
  }

  Future<void> _addPicture() async {
    Uint8List picture;
    try {
      picture = (await (await MultiImagePicker.pickImages(maxImages: 1))[0]
              .getByteData())
          .buffer
          .asUint8List();
    } catch (error) {
      return;
    }
    setState(() => _picture = picture);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        redux.Store<AppState> store,
        AppState state,
        void Function(redux.ReduxAction<AppState>) dispatch,
        Widget child) {
      return View(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
                controller: description,
                decoration: InputDecoration(labelText: 'Description')),
            Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
              if (_picture == null)
                Container(
                    //width: MediaQuery.of(context).size.width * 0.3,
                    child: Image.asset(
                  'images/default-user-profile-image-png-7.png',
                ))
              else
                Image.memory(_picture),
              GestureDetector(
                  onTap: () => _addPicture(),
                  child: Container(child: Icon(Icons.add)))
            ]),
            Button(
              text: 'Create',
              onPressed: () => onSave(dispatch),
            )
          ]));
    });
  }
}
