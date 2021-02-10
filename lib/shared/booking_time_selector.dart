import 'package:flutter/material.dart';
import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/bookings.service.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:anthonybookings/shared/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class BookingTimeSelector extends StatefulWidget {
  final Function updateSelectedDate;

  BookingTimeSelector({this.updateSelectedDate});

  @override
  _BookingTimeSelectorState createState() => _BookingTimeSelectorState();
}

class _BookingTimeSelectorState extends State<BookingTimeSelector> {
  List<TimeOfDay> availableTimes = bookingIntervalTimes;
  DateTime selectedDate = DateTime.now();
  bool isTimeListLoading = false;


  // Updates the available appointments list based on the current date selected on the calender
  void updateAvailableTimes() async {

    List<TimeOfDay> newAvailableTimes = [];
    isTimeListLoading = true;

    List<Booking> bookingsOnDay = await BookingService().getBookingsOnDay(new DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day
    ));

    for (var timeValue in bookingIntervalTimes) {
      bool isAvailable = true;

      for (var booking in bookingsOnDay) {
        if (TimeOfDay.fromDateTime(booking.dateTime).hour == timeValue.hour
            && TimeOfDay.fromDateTime(booking.dateTime).minute == timeValue.minute) {
          isAvailable = false;
          break;
        }
      }

      if (isAvailable) {
        newAvailableTimes.add(timeValue);
      }
    }

    setState(() {
      isTimeListLoading = false;
      availableTimes = newAvailableTimes;
    });
  }

  @override
  void initState() {
    updateAvailableTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 1000)),
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                  updateAvailableTimes();
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
                      widget.updateSelectedDate(selectedDate);
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
    );
  }
}
