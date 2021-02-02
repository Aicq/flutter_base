class BookingUser {

  String uid;
  String email;
  String password;
  String firstName;
  String lastName;
  int isAdmin;

  BookingUser({this.uid, this.email, this.password, this.isAdmin, this.firstName, this.lastName});

}
//import 'package:flutter/material.dart';
//
//class BookingUser {
//  int _uid;
//  String _email;
//  String _password;
//  bool _isAdmin;
//
//  BookingUser({int uid, @required String email, @required String password, bool isAdmin = false})
//      : _uid = uid,  // optional parameter without default value
//        _email = email,  // required parameter
//        _password = password;  // required parameter
//  _isAdmin = isAdmin; // optional parameter with default value false
//}
