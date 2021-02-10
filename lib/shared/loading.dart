import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.indigo[500],
          size: 50.0,
        ),
      ),
    );
  }
}