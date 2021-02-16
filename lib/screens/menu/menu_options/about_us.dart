import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Serving residents of the Gold Coast for over 20 years.',
              style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 50.0,
              color: Theme.of(context).accentColor,
            ),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              style: TextStyle(
                letterSpacing: 2.0,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
