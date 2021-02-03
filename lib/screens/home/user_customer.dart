import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booking_form.dart';

class UserCustomer extends StatefulWidget {

  final BookingUser user;
  UserCustomer({this.user});

  @override
  _UserCustomerState createState() => _UserCustomerState();
}

class _UserCustomerState extends State<UserCustomer> {

  final List<Booking> bookings = [
    Booking(customerId: '1234', providerId: 'VqSnxfJzW7VKqEfsAY95QUvBajX2', dateTime: DateTime.now(), description: 'A quick checkup1', additionalDetails: 'Allergic to panadol'),
    Booking(customerId: '1234', providerId: 'VqSnxfJzW7VKqEfsAY95QUvBajX2', dateTime: DateTime.now(), description: 'A quick checkup2', additionalDetails: 'Allergic to panadol'),
  ];


  Future<BookingUser> getProviderFromBooking(Booking booking) async {
    return await UserService().singleUser(booking.providerId);
  }

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
            RaisedButton(
              color: Colors.indigo[400],
              child: Text(
                'Make a Booking',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookingForm(user: widget.user)));
              }
            ),
            ListTile(
              title: Text('Your Bookings'),
              tileColor: Colors.lightGreen[200],
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                    future: getProviderFromBooking(bookings[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListTile(
//                          leading: CircleAvatar(), // Maybe put provider image here?
                          leading: Text('Doctor:\n${snapshot.data.firstName}'),
                          subtitle: Text('${bookings[index].additionalDetails}'),
                          title: Text('${bookings[index].description}'),
                          trailing: Text('${DateFormat('kk:mm').format(bookings[index].dateTime)}'),
                        );
                      }
                      return CircularProgressIndicator();
                    },
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
