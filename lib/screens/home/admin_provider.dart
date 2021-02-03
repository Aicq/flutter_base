import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminProvider extends StatefulWidget {

  final BookingUser user;
  AdminProvider({this.user});

  @override
  _AdminProviderState createState() => _AdminProviderState();
}

class _AdminProviderState extends State<AdminProvider> {

  final List<Booking> bookings = [
    Booking(customerId: '1234', providerId: 'VqSnxfJzW7VKqEfsAY95QUvBajX2', dateTime: DateTime.now(), description: 'A quick checkup1', additionalDetails: 'Allergic to panadol'),
    Booking(customerId: '4567', providerId: 'VqSnxfJzW7VKqEfsAY95QUvBajX2', dateTime: DateTime.now(), description: 'A quick checkup2', additionalDetails: 'Allergic to panadol'),
    Booking(customerId: '134641', providerId: 'VqSnxfJzW7VKqEfsAY95QUvBajX2', dateTime: DateTime.now(), description: 'A quick checkup3', additionalDetails: 'Allergic to panadol'),
    Booking(customerId: '123451', providerId: 'VqSnxfJzW7VKqEfsAY95QUvBajX2', dateTime: DateTime.now(), description: 'A quick checkup4', additionalDetails: 'Allergic to panadol'),
    Booking(customerId: '13451345', providerId: 'VqSnxfJzW7VKqEfsAY95QUvBajX2', dateTime: DateTime.now(), description: 'A quick checkup5', additionalDetails: 'Allergic to panadol'),
  ];

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
//                decoration: BoxDecoration(
//                  color: Colors.lightGreen[100]
//                ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Welcome ${widget.user.firstName}!',
                style: TextStyle(
                  fontSize: 20.0,
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
              title: Text('Bookings Scheduled'),
              trailing: Text('${DateFormat('dd / MM / yy').format(selectedDate)}'),
              tileColor: Colors.lightGreen[200],
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(), // Maybe put customer image here?
                    subtitle: Text('${bookings[index].additionalDetails}'),
                    title: Text('${bookings[index].description}'),
                    trailing: Text('${DateFormat('kk:mm').format(bookings[index].dateTime)}'),
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
    );
  }
}
