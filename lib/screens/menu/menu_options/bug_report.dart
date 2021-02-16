import 'dart:io';

import 'package:anthonybookings/shared/ac-snackbar.dart';
import 'package:anthonybookings/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class BugReport extends StatefulWidget {
  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  final _formKeyBugReport = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> attachments = [];
  Email newEmail;

  Future<void> send() async {
    if (_formKeyBugReport.currentState.validate()) {
      final Email email = Email(
        body: _bodyController.text,
        subject: 'BUG REPORT for Anthony Bookings - ' + _subjectController.text,
        recipients: ['anthony@inthecode.com.au'],
        attachmentPaths: attachments,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        _bodyController.clear();
        _subjectController.clear();
        setState(() {
          attachments = [];
        });
        platformResponse = 'Email Sent!';
      } catch (error) {
        platformResponse = error.toString();
      }

      if (!mounted) {
        return;
      }

      _scaffoldKey.currentState.showSnackBar(getACSnackbar(platformResponse, false));
    }
  }

  Future _openImagePicker() async {
    final pick = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        attachments.add(pick.path);
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Report a Bug"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
          child: Form(
            key: _formKeyBugReport,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Noticed something not working how it should?\nLet us know!",
                    style: TextStyle(
                        letterSpacing: 2.0,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 50.0,
                    color: Theme.of(context).accentColor,
                  ),
                  TextFormField(
                    controller: _subjectController,
                    decoration: textInputDecoration(context)
                        .copyWith(hintText: 'Subject'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return value.isEmpty ? 'Enter a subject!' : null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _bodyController,
                    decoration:
                        textInputDecoration(context).copyWith(hintText: 'Body'),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 5,
                    validator: (value) {
                      return value.isEmpty ? 'Enter a body!' : null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    leading: Icon(Icons.attach_file),
                    title: Text('Add any helpful screenshots / images'),
                    onTap: () {
                      _openImagePicker();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Wrap(
                      children: [
                        for (var i = 0; i < attachments.length; i++)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                  flex: 0,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width: 100,
                                    height: 100,
                                    child: Image.file(File(attachments[i]),
                                        fit: BoxFit.cover),
                                  )),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () => {_removeAttachment(i)},
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      'Send Email',
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () async {
                      await send();
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
