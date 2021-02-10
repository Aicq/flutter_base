import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/bookings.service.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:anthonybookings/shared/booking_time_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsPanel extends StatefulWidget {

  Booking booking;
  BookingUser customer;
  BookingUser provider;
  final Function fetchUserBookings;
  DetailsPanel({this.booking, this.customer, this.provider, this.fetchUserBookings});

  @override
  _DetailsPanelState createState() => _DetailsPanelState();
}

class _DetailsPanelState extends State<DetailsPanel> {
  final _formKeyDescription = GlobalKey<FormState>();

  bool isProviderEdit = false;
  bool isCustomerEdit = false;
  bool isDescriptionEdit = false;
  bool isAdditionalEdit = false;
  bool isDateTimeEdit = false;
  String editedAdditional;
  String editedDescription;
  DateTime editedDateTime;
  Future<List<BookingUser>> providerListFuture;

  Future<List<BookingUser>> getProviders() async {
    return await UserService().fetchUsers('isAdmin', 1);
  }

  void updateSelectedDate(DateTime selectedDate) {
    Navigator.pop(context);
    setState(() {
      editedDateTime = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BookingUser>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text(
                  'Cancel Booking',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.red[300],
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm'),
                        content: Text('Are you sure you want to cancel your booking?'),
                        actions: [
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              await BookingService().removeBooking(widget.booking.id);
                              widget.fetchUserBookings(user.uid);
                              // Pop alert modal and details bottom panel
                              Navigator.pop(context); // Alert modal
                              Navigator.pop(context); // Details
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Doctor:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: isProviderEdit ? FutureBuilder(
                  future: providerListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return DropdownButtonFormField(
                        key: ValueKey('detailsProviderDropdown'),
                        hint: Text('Select a doctor'),
                        value: widget.provider,
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
                            widget.provider = newVal;
                            widget.booking.providerId = newVal.uid;
                          });
                        },
                      );
                    }
                    return Row(
                      children: [
                        Text('Retrieving list of doctors...'),
                        SizedBox(width: 50.0,),
                        SpinKitChasingDots(
                          color: Colors.black,
                          size: 20.0,
                        ),
                      ],
                    );
                  },
                ) : Text(
                  '${widget.provider.firstName} ${widget.provider.lastName}',
                  style: TextStyle(
                      fontSize: 18.0,
                  ),
                ),
                trailing: isProviderEdit ? IconButton(
                  icon: Icon(Icons.save),
                  color: Colors.green,
                  onPressed: () async {
                    await BookingService().addEditBooking(widget.booking);
                    setState(() {
                      isProviderEdit = false;
                    });
                    widget.fetchUserBookings(user.uid);
                  },
                ) : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    setState(() {
                      providerListFuture = getProviders();
                      isProviderEdit = true;
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Patient:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  '${widget.customer.firstName} ${widget.customer.lastName}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isDescriptionEdit ? Form(
                  key: _formKeyDescription,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                    initialValue: widget.booking.description,
                    validator: (value) {
                      return value.isEmpty ? 'Enter an description!' : null;
                    },
                    onChanged: (value) {
                      setState(() {
                        editedDescription = value;
                      });
                    },
                  ),
                ) : Text(
                  '${widget.booking.description}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                trailing: isDescriptionEdit ? IconButton(
                  icon: Icon(Icons.save),
                  color: Colors.green,
                  onPressed: () async {
                    if (_formKeyDescription.currentState.validate()) {
                      setState(() {
                        if (editedDescription != null) {
                          widget.booking.description = editedDescription;
                        }
                        isDescriptionEdit = false;
                      });
                      await BookingService().addEditBooking(widget.booking);
                      widget.fetchUserBookings(user.uid);
                    }
                  },
                ) : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isDescriptionEdit = true;
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Additional Details:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: isAdditionalEdit ? Form(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                    initialValue: widget.booking.additionalDetails,
                    onChanged: (value) {
                      setState(() {
                        editedAdditional = value;
                      });
                    },
                  ),
                ) : Text(
                  '${widget.booking.additionalDetails != null && widget.booking.additionalDetails.length > 0 ?
                      widget.booking.additionalDetails : '-'}',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                trailing: isAdditionalEdit ? IconButton(
                  icon: Icon(Icons.save),
                  color: Colors.green,
                  onPressed: () async {
                    setState(() {
                      if (editedAdditional != null) {
                        widget.booking.additionalDetails = editedAdditional;
                      }
                      isAdditionalEdit = false;
                    });
                    await BookingService().addEditBooking(widget.booking);
                    widget.fetchUserBookings(user.uid);
                  },
                ) : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isAdditionalEdit = true;
                    });
                  },
                ),
              ),
              Divider(),
              Column(
                children: [
                  ListTile(
                    title: isDateTimeEdit && editedDateTime != null ? Text(
                      'New Date:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),
                    ) : Text(
                      'Date:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text(
                      '${isDateTimeEdit && editedDateTime != null ? DateFormat('dd/MM/yy').format(editedDateTime)
                          : DateFormat('dd/MM/yy').format(widget.booking.dateTime)}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    trailing: isDateTimeEdit ? IconButton(
                      icon: Icon(Icons.save),
                      color: Colors.green,
                      onPressed: () async {
                        setState(() {
                          if (editedDateTime != null) {
                            widget.booking.dateTime = editedDateTime;
                          }
                          isDateTimeEdit = false;
                          // Reset to null to avoid incorrect subtitle text styles being applied if user edits again
                          editedDateTime = null;
                        });
                        await BookingService().addEditBooking(widget.booking);
                        widget.fetchUserBookings(user.uid);
                      },
                    ) : IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          isDateTimeEdit = true;
                        });
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                    child: BookingTimeSelector(updateSelectedDate: updateSelectedDate),
                                    height: MediaQuery.of(context).size.height * 0.8,
                                    width:  MediaQuery.of(context).size.width * 0.8
                                ),
                              );
                            }
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: isDateTimeEdit && editedDateTime != null ? Text(
                      'New Time:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),
                    ) : Text(
                      'Time:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text(
                      '${isDateTimeEdit && editedDateTime != null ? DateFormat('kk:mm').format(editedDateTime)
                          : DateFormat('kk:mm').format(widget.booking.dateTime)}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Location:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '41 Smith Street 4218',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
//                trailing: IconButton(
//                  icon: Icon(Icons.edit),
//                  onPressed: () {
//                    print('123123123');
//                  },
//                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
