import 'package:flutter/material.dart';

InputDecoration textInputDecoration(BuildContext context) {
  return InputDecoration(
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
    ),
  );
}

const bookingIntervalTimes = [
  TimeOfDay(hour: 9, minute: 00),
  TimeOfDay(hour: 9, minute: 30),
  TimeOfDay(hour: 10, minute: 00),
  TimeOfDay(hour: 10, minute: 30),
  TimeOfDay(hour: 11, minute: 00),
  TimeOfDay(hour: 11, minute: 30),
  TimeOfDay(hour: 12, minute: 00),
  TimeOfDay(hour: 12, minute: 30),
  TimeOfDay(hour: 13, minute: 00),
  TimeOfDay(hour: 13, minute: 30),
  TimeOfDay(hour: 14, minute: 00),
  TimeOfDay(hour: 14, minute: 30),
  TimeOfDay(hour: 15, minute: 00),
  TimeOfDay(hour: 15, minute: 30),
  TimeOfDay(hour: 16, minute: 00),
];