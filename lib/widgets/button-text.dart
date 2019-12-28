import 'package:flutter/material.dart';
import 'package:inclusive/theme.dart';

class ButtonText extends StatefulWidget {
  final String text;
  final double width;
  final Function isSelected;
  final Function onTap;

  ButtonText({this.text, this.width, this.isSelected, this.onTap});

  @override
  ButtonTextState createState() {
    return ButtonTextState();
  }
}

class ButtonTextState extends State<ButtonText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.isSelected() ? orange : blue,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
