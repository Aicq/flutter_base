import 'package:anthonybookings/services/auth.dart';
import 'package:anthonybookings/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:anthonybookings/shared/constants.dart';

class Login extends StatefulWidget {

  final Function toggleView;
  Login({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Sign in'),
          actions: [
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Register'),
                onPressed: () {
                  widget.toggleView();
                }
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  key: ValueKey('email'),
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return value.isEmpty ? 'Enter an email!' : null;
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },

                ),
                SizedBox(height: 20.0),
                TextFormField(
                  key: ValueKey('password'),
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    return value.length < 6 ? 'Enter a password 6+ chars long' : null;
                  },
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  key: ValueKey('loginButton'),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
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
        )
    );
  }
}
