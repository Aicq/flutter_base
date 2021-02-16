import 'package:flutter/material.dart';

SnackBar getACSnackbar(String textContent, bool isError) {
  return SnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.floating,
    content: SizedBox(
      height: 25.0,
      child: Center(
        child: Text(
          textContent,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    ),
    margin: EdgeInsets.all(20.0),
    padding: EdgeInsets.all(8.0),
  );
}
