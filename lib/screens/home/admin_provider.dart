import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/bookings.service.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class AdminProvider extends StatefulWidget {

  final BookingUser user;
  AdminProvider({this.user});

  @override
  _AdminProviderState createState() => _AdminProviderState();
}

class _AdminProviderState extends State<AdminProvider> {

  List<Booking> bookings = [];
  DateTime selectedDate = DateTime.now();
  bool isBookingsListLoading = false;

  void fetchUserBookings(String userId, DateTime dateTime) async {
    isBookingsListLoading = true;
    List<Booking> newBookings = await BookingService().getProviderBookings(userId, dateTime);

    setState(() {
      bookings = newBookings;
      isBookingsListLoading = false;
    });
  }


  Future<BookingUser> getCustomerFromBooking(Booking booking) async {
    return await UserService().singleUser(booking.customerId);
  }

  @override
  void initState() {
    fetchUserBookings(widget.user.uid, DateTime.now());
    super.initState();
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
            CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime(2010),
                lastDate: DateTime(2100),
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                    fetchUserBookings(widget.user.uid, selectedDate);
                  });
                }
            ),
            ListTile(
              title: Text('Bookings Scheduled'),
              trailing: Text('${DateFormat('dd / MM / yy').format(selectedDate)}'),
              tileColor: Theme.of(context).accentColor,
            ),
            isBookingsListLoading ? Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: SpinKitDualRing(color: Theme.of(context).accentColor),
            ) : Expanded(
              child: bookings.length == 0 ? Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text('Nothing scheduled'),
              ) : ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                    future: getCustomerFromBooking(bookings[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: snapshot.data.imageUrl != null ? NetworkImage(snapshot.data.imageUrl) :
                              AssetImage('assets/default_user_pic.png'),
                            radius: 25.0,
                          ),
                          subtitle: Text('Patient: ${snapshot.data.firstName}'),
                          title: Text('${bookings[index].description}'),
                          trailing: Text('${DateFormat('kk:mm').format(bookings[index].dateTime)}'),
                        );
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: SpinKitThreeBounce(
                            color: Colors.blueGrey,
                            size: 20.0,
                          ),
                        ),
                      );
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
