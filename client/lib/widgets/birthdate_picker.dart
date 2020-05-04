import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart'
    show DatePickerWidget, DateTimePickerTheme;

class BirthdatePicker extends StatelessWidget {
  BirthdatePicker({this.initial, this.onChange});

  final DateTime now = DateTime.now();
  final DateTime initial;
  final void Function(DateTime) onChange;

  @override
  Widget build(BuildContext context) {
    return DatePickerWidget(
        maxDateTime: DateTime(now.year - 13, now.month, now.day),
        minDateTime: DateTime(now.year - 99, now.month, now.day),
        initialDateTime: initial,
        pickerTheme: const DateTimePickerTheme(showTitle: false),
        onChange: (DateTime dateTime, _) => onChange(dateTime));
  }
}
