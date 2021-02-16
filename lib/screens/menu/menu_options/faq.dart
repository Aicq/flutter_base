import 'package:flutter/material.dart';

class Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Frequently Asked Questions"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need some help?\nThese are our most commonly asked questions.',
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
              'Do you do bulk billing?',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
                fontSize: 23.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Yes, our medical practice offers bulk billing to all patients',
              style: TextStyle(
                  letterSpacing: 2.0,
                  fontSize: 18.0,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Question 2?',
              style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Answer 2',
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
