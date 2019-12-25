import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class BirthdatePicker extends StatelessWidget {
  final DateTime now = DateTime.now();
  final DateTime initial;
  final Function onChange;
  final DateTimePickerTheme theme;

  BirthdatePicker({Key key, this.initial, this.onChange, this.theme = const DateTimePickerTheme()});

  @override
  Widget build(BuildContext context) {
  return  DatePickerWidget(
        maxDateTime: DateTime(now.year - 13, now.month, now.day),
        minDateTime: DateTime(now.year - 99, now.month, now.day),
        initialDateTime: initial,
        pickerTheme: theme,
        onCancel: () => print('ok'),
        onChange: (dateTime, _) => onChange(dateTime),
      );
  }
}