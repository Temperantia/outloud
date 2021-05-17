import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:outloud/theme.dart';

class MultilineTextField extends StatefulWidget {
  const MultilineTextField({this.controller, this.formatters, this.hint});

  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final String hint;

  @override
  _MultilineTextFieldState createState() => _MultilineTextFieldState();
}

class _MultilineTextFieldState extends State<MultilineTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
        config: KeyboardActionsConfig(),
        child: TextField(
            focusNode: focusNode,
            controller: widget.controller,
            keyboardType: TextInputType.multiline,
            inputFormatters: widget.formatters,
            maxLines: null,
            decoration: InputDecoration.collapsed(
                hintStyle: const TextStyle(color: white),
                border: InputBorder.none,
                hintText: widget.hint)));
  }
}
