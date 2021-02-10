import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:anthonybookings/shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // text field states
  String error = '';

  BookingUser newUser = new BookingUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Sign up'),
          actions: [
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Sign In'),
                onPressed: () {
                  widget.toggleView();
                }
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration(context).copyWith(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return value.isEmpty ? 'Enter an email!' : null;
                    },
                    onChanged: (value) {
                      setState(() {
                        newUser.email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration(context).copyWith(hintText: 'First Name'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value.isEmpty ? 'Enter an first name!' : null;
                    },
                    onChanged: (value) {
                      setState(() {
                        newUser.firstName = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration(context).copyWith(hintText: 'Last Name'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return value.isEmpty ? 'Enter an last name!' : null;
                    },
                    onChanged: (value) {
                      setState(() {
                        newUser.lastName = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration(context).copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      return value.length < 6 ? 'Enter a password 6+ chars long' : null;
                    },
                    onChanged: (value) {
                      setState(() {
                        newUser.password = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        dynamic result = await _auth.registerWithEmailAndPassword(newUser);
                        if (result == null) {
                          setState(() {
                            error = 'Please supply a valid email';
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
