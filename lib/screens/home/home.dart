import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/auth.dart';
import 'package:anthonybookings/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  final List<String> messages = const [
    'Message 1',
    'Message 2',
    'Message 3',
    'Message 4',
  ];

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BookingUser>(context);

    return StreamBuilder<BookingUser>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            BookingUser user = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                title: Text('Bookings - ${user.isAdmin > 0 ? 'Admin' : 'User'}'),
                actions: [
                  FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Logout'),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
              body: user.isAdmin > 0 ? Container(
//                decoration: BoxDecoration(
//                  color: Colors.lightGreen[100]
//                ),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Welcome ${user.firstName}!',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      ),
                      ListTile(
                        title: Text('Appointments Scheduled'),
                        trailing: Text('${DateFormat('dd / MM / yy').format(selectedDate)}'),
                        tileColor: Colors.lightGreen[200],
                      ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading: CircleAvatar(),
                                subtitle: Text('Another Text'),
                                title: Text('${messages[index]}')
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ) : Text('Nothing for user yet')
            );
          } else {
            return Text('no data');
          }
        },
    );
  }
}
