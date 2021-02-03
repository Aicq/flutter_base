import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

const bookingIntervalTimes = [
  TimeOfDay(hour: 8, minute: 00),
  TimeOfDay(hour: 8, minute: 15),
  TimeOfDay(hour: 8, minute: 30),
  TimeOfDay(hour: 8, minute: 45),
  TimeOfDay(hour: 9, minute: 00),
  TimeOfDay(hour: 9, minute: 15),
  TimeOfDay(hour: 18, minute: 15),
];