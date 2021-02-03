import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/bookings.service.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:anthonybookings/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class BookingForm extends StatefulWidget {

  final BookingUser user;
  BookingForm({this.user});

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = PageController(
    initialPage: 0,
  );

  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  BookingUser selectedProvider;
  String error = '';
  Future<List<BookingUser>> providerListFuture;
  Booking newBooking;
  bool isTimeListLoading = false;
  List<TimeOfDay> availableTimes = bookingIntervalTimes;

  Future<List<BookingUser>> getProviders() async {
    return await UserService().fetchUsers('isAdmin', 1);
  }

  void updateAvailableTimes() async {

    List<TimeOfDay> newAvailableTimes = [];
    isTimeListLoading = true;

    for (var timeValue in bookingIntervalTimes) {
      bool exists = await BookingService().doesBookingExist(new DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        timeValue.hour,
        timeValue.minute,
      ));

      if (exists) {
        continue;
      }

      newAvailableTimes.add(timeValue);
    }

    setState(() {
      isTimeListLoading = false;
      availableTimes = newAvailableTimes;
    });
  }

  @override
  void initState() {
    providerListFuture = getProviders();
    newBooking = Booking(customerId: widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Booking'),
      ),
      body: PageView(
        controller: controller,
        children: [

          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: providerListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return DropdownButtonFormField(
                          hint: Text('Select a doctor'),
                          value: selectedProvider,
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
                CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 1000)),
                    onDateChanged: (date) {
                      setState(() {
                        selectedDate = date;
                        updateAvailableTimes();
//                        newBooking.dateTime = date;
                      });
                    }
                ),
                ListTile(
                  title: Text('Available Bookings - ${DateFormat('dd / MM / yy').format(selectedDate)}'),
                  tileColor: Colors.lightGreen[200],
                ),
                isTimeListLoading ? Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: SpinKitDualRing(color: Colors.deepPurple),
                ) : Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: availableTimes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text('${availableTimes[index].format(context)}'),
                        onTap: () {
                          setState(() {
                            selectedDate = new DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              availableTimes[index].hour,
                              availableTimes[index].minute,
                            );
                            newBooking.dateTime = selectedDate;
                          });
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
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
                          'Date: ${DateFormat('dd / MM / yy').format(selectedDate)}\n'
                          'Time: ${DateFormat('kk:mm').format(selectedDate)}',
                          style: TextStyle(
                            height: 2.0
                          )),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      child: Text(
                        'Book Me In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          dynamic result = BookingService().addEditBooking(newBooking); // Send request to add new booking
                          if (result == null) {
                            setState(() {
                              error = 'Error adding booking, please try again.';
                              isLoading = false;
                            });
                          }
                          Navigator.pop(context);
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
            ),
          ),
        ],
      )
    );
  }
}
