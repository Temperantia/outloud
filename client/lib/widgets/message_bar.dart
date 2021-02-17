import 'dart:typed_data';

import 'package:business/classes/message.dart';
import 'package:business/models/event_message.dart';
import 'package:business/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:outloud/functions/firebase.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/multiline_text_field.dart';

class MessageBar extends StatefulWidget {
  const MessageBar(
      {this.userId,
      this.chatId,
      this.messageController,
      this.scrollController,
      this.hint,
      this.isEvent = false});

  final String userId;
  final String chatId;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final String hint;
  final bool isEvent;

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  void _onMessage() {
    final String text = widget.messageController.text.trim();
    if (text.isEmpty) {
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(context, 'CHAT.NO_MESSAGE'));
    } else {
      addMessage(widget.chatId, widget.userId, text, MessageType.Text);
      widget.messageController.clear();
      widget.scrollController.jumpTo(0.0);
    }
  }

  Future<void> _onImage() async {
    try {
      final Uint8List image =
          (await (await MultiImagePicker.pickImages(maxImages: 1))[0]
                  .getByteData())
              .buffer
              .asUint8List();
      final String url =
          await saveImage(image, 'images/events/${widget.chatId}');
      addEventMessage(widget.chatId, widget.userId, url, MessageType.Image);
      widget.scrollController.jumpTo(0.0);
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: orangeLight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(children: <Widget>[
          if (widget.isEvent)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () => _onImage(),
                    child: const Icon(Icons.panorama, color: white))),
          /*   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {}, child: Icon(Icons.add, color: white))), */
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MultilineTextField(
                      controller: widget.messageController,
                      hint: widget.hint))),
          /*   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {},
                        child:
                            const Icon(MdiIcons.stickerEmoji, color: white))), */
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => _onMessage(),
                  child: const Icon(Icons.send, color: white)))
        ]));
  }
}
