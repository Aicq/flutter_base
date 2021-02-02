import 'package:anthonybookings/screens/login/login.dart';
import 'package:anthonybookings/screens/login/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showLogin ? Login(toggleView: toggleView) : Register(toggleView: toggleView),
    );
  }
}
