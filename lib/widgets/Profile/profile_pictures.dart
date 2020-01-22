import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/theme.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class ProfilePictures extends StatefulWidget {
  const ProfilePictures(this.pics, {Key key}) : super(key: key);

  final List<dynamic> pics;

  @override
  ProfilePicturesState createState() => ProfilePicturesState();
}

class ProfilePicturesState extends State<ProfilePictures> {
  AppDataService _appDataService;
  final List<dynamic> _pictures = <dynamic>[];
  final List<String> _picturesToDelete = <String>[];

  @override
  void initState() {
    super.initState();
    widget.pics.forEach(_pictures.add);
  }

  Future<List<String>> onSave(String userId) async {
    for (final String pictureToDelete in _picturesToDelete) {
      _appDataService.deleteImage(pictureToDelete, userId);
    }

    return Future.wait<String>(_pictures.map((dynamic picture) async {
      if (picture is Uint8List) {
        return await _appDataService.saveImage(picture, userId);
      }
      return picture as String;
    }).toList());
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
    setState(() => _pictures.add(picture));
  }

  Future<void> _removePicture(dynamic picture) async {
    if (picture is String) {
      _picturesToDelete.add(picture);
    }
    setState(() => _pictures.remove(picture));
  }

  Widget _buildPicture(dynamic picture) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
      Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: picture is Uint8List
              ? Image.memory(picture, key: ValueKey<Uint8List>(picture))
              : Image.network(picture as String,
                  key: ValueKey<String>(picture as String))),
      GestureDetector(
          onTap: () => _removePicture(picture),
          child: Container(
              decoration: BoxDecoration(color: white, shape: BoxShape.circle),
              child: Icon(Icons.close, color: red)))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _appDataService = Provider.of<AppDataService>(context);

    return ReorderableWrap(
      spacing: 8.0,
      padding: const EdgeInsets.all(8.0),
      onReorder: (int oldIndex, int newIndex) => setState(() {
        if (oldIndex >= _pictures.length) {
          return;
        }
        final dynamic picture = _pictures[oldIndex];
        if (newIndex >= _pictures.length) {
          newIndex = _pictures.length - 1;
        }
        _pictures.removeAt(oldIndex);
        _pictures.insert(newIndex, picture);
      }),
      children: <Widget>[
        for (final dynamic picture in _pictures) _buildPicture(picture),
        for (int index = _pictures.length; index < 9; index++)
          Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Image.asset(
                    'images/default-user-profile-image-png-7.png',
                    key: ValueKey<int>(index))),
            GestureDetector(
                onTap: () => _addPicture(),
                child: Container(
                    decoration:
                        BoxDecoration(color: orange, shape: BoxShape.circle),
                    child: Icon(Icons.add, color: white)))
          ])
      ],
    );
  }
}
