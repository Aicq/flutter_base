import 'package:flutter/material.dart';

ThemeData getLightTheme(brightness) {
  return ThemeData(
//    primarySwatch: Colors.deepPurple,
//    buttonColor: Colors.blueGrey,
//    scaffoldBackgroundColor: Colors.grey[100],
//    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple),
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.green[200],
    brightness: brightness,
  );
}

ThemeData getDarkTheme(brightness) {
  return ThemeData(
//    primarySwatch: Colors.deepPurple,
//    buttonColor: Colors.blueGrey,
//    scaffoldBackgroundColor: Colors.grey[100],
    accentColor: Colors.red[900],
    brightness: brightness,
    buttonColor: Colors.blueGrey,
  );
}
