import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/bookings.service.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'booking_form.dart';
import 'details_panel.dart';

class UserCustomer extends StatefulWidget {

  final BookingUser user;
  UserCustomer({this.user});

  @override
  _UserCustomerState createState() => _UserCustomerState();
}

class _UserCustomerState extends State<UserCustomer> {

  List<Booking> bookings = [];
  bool isBookingsListLoading = false;

  void fetchUserBookings(String userId) async {
    isBookingsListLoading = true;
    List<Booking> newBookings = await BookingService().getUserBookings(userId);

    setState(() {
      bookings = newBookings;
      isBookingsListLoading = false;
    });
  }

  Future<BookingUser> getProviderFromBooking(Booking booking) async {
    return await UserService().singleUser(booking.providerId);
  }

  @override
  void initState() {
    fetchUserBookings(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    void _showDetailsPanel(Booking booking, BookingUser customer, BookingUser provider) {
      showModalBottomSheet(context: context, builder: (context) {
        return DetailsPanel(booking: booking, customer: customer, provider: provider, fetchUserBookings: fetchUserBookings);
      });
    }

    return Scaffold(
      body: Container(
//                decoration: BoxDecoration(
//                  color: Colors.lightGreen[100]
//                ),
        child: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/medical_bg.jpg'),
                    fit: BoxFit.cover
                  )
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Welcome ${widget.user.firstName}!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80.0, bottom: 30.0),
                      child: RaisedButton(
                          key: Key('addBooking'),
                          color: Colors.indigo[400],
                          child: Text(
                            'Make a Booking',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingForm(user: widget.user,fetchUserBookings: fetchUserBookings)));
                          }
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('Your Bookings'),
                tileColor: Colors.lightGreen[200],
              ),
              isBookingsListLoading ? Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SpinKitDualRing(color: Colors.deepPurple),
              ) : Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: bookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                      future: getProviderFromBooking(bookings[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          return ListTile(
                            // Maybe put provider image here?
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('assets/default_user_pic.png'),
                              radius: 25.0,
                            ),
                            subtitle: Text('Doctor: ${snapshot.data.firstName}'),
                            title: Text('${bookings[index].description}'),
                            trailing: Text('${DateFormat('dd/MM/yy').format(bookings[index].dateTime)}\n${DateFormat('kk:mm').format(bookings[index].dateTime)}'),
                            onTap: () {
                              _showDetailsPanel(bookings[index], widget.user, snapshot.data);
                            },
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
      ),
    );
  }
}
