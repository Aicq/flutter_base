import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/bookings.service.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:anthonybookings/shared/booking_time_selector.dart';
import 'package:anthonybookings/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class BookingForm extends StatefulWidget {

  final BookingUser user;
  final Function fetchUserBookings;
  BookingForm({this.user, this.fetchUserBookings});

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final controller = PageController(
    initialPage: 0,
  );
  final Curve pageScrollCurve = Curves.linear;

  bool isLoading = false;
  BookingUser selectedProvider;
  String error = '';
  Future<List<BookingUser>> providerListFuture;
  Booking newBooking;

  Future<List<BookingUser>> getProviders() async {
    return await UserService().fetchUsers('isAdmin', 1);
  }

  void updateSelectedDate(DateTime selectedDate) {
    setState(() {
      if (_formKeyPage1.currentState.validate()) {
        newBooking.dateTime = selectedDate;
        controller.nextPage(duration: Duration(milliseconds: 500), curve: pageScrollCurve);
      }
    });
  }

  @override
  void initState() {
    providerListFuture = getProviders();
    newBooking = Booking(customerId: widget.user.uid, description: 'Routine checkup');
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Booking'),
      ),
      body: PageView(
        controller: controller,
        physics: new NeverScrollableScrollPhysics(), // Disable scrolling
        children: [
          Container(
            child: Form(
              key: _formKeyPage1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                      future: providerListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return DropdownButtonFormField(
                            key: ValueKey('providerDropdown'),
                            hint: Text('Select a doctor'),
                            value: selectedProvider,
                            validator: (value) {
                              return value == null ? 'Select a doctor!' : null;
                            },
                            items: snapshot.data.map<DropdownMenuItem<BookingUser>>((BookingUser user) {
                              return DropdownMenuItem(
                                value: user,
                                child: Text('${user.firstName} ${user.lastName}'),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                selectedProvider = newVal;
                                newBooking.providerId = selectedProvider.uid;
                              });
                            },
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  BookingTimeSelector(updateSelectedDate: updateSelectedDate),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKeyPage2,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      initialValue: newBooking.description,
                      validator: (value) {
                        return value.isEmpty ? 'Enter an description!' : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          newBooking.description = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Additional Details (Allergies, concerns, etc.)'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (value) {
                        setState(() {
                          newBooking.additionalDetails = value;
                        });
                      },
                    ),
                    Divider(height: 40.0),
                    Card(
                      child: ListTile(
                        title: Text('Summary'),
                        trailing: Icon(Icons.calendar_today),
                        subtitle: Text(
                          'Doctor: ${selectedProvider?.firstName} ${selectedProvider?.lastName}\n'
                          'Date: ${newBooking.dateTime != null ? DateFormat('dd / MM / yy').format(newBooking.dateTime) : ''}\n'
                          'Time: ${newBooking.dateTime != null ? DateFormat('kk:mm').format(newBooking.dateTime) : ''}',
                          style: TextStyle(
                            height: 2.0
                          )),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          color: Colors.deepPurple[100],
                          onPressed: () {
                            controller.previousPage(duration: Duration(milliseconds: 500), curve: pageScrollCurve);
                          },
                        ),
                        RaisedButton(
                          child: Text(
                            'Book Me In',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKeyPage2.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              dynamic result = await BookingService().addEditBooking(newBooking); // Send request to add new booking
                              if (result == null) {
                                setState(() {
                                  error = 'Error adding booking, please try again.';
                                  isLoading = false;
                                });
                                return;
                              }
                              widget.fetchUserBookings(widget.user.uid);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
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
          ),
        ],
      )
    );
  }
}
