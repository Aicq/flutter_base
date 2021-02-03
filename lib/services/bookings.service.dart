import 'package:anthonybookings/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  // collection reference
  final CollectionReference bookingCollection = FirebaseFirestore.instance.collection('bookings');

  // userData from snapshot
  Booking _bookingDataFromSnapshot(dynamic snapshot) {
    return Booking(
      customerId: snapshot.data()['customerId'],
      providerId: snapshot.data()['providerId'],
      dateTime: snapshot.data()['dateTime'].toDate(),
      description: snapshot.data()['description'],
      additionalDetails: snapshot.data()['additionalDetails'],
    );
  }

  // Used to add/update a user
  Future addEditBooking(Booking booking) async {
//    if (booking.reference == null) {
//      // Generate unique id or ref number
//    }

    return await bookingCollection.doc().set({
      'customerId': booking.customerId,
      'providerId': booking.providerId,
      'dateTime': booking.dateTime,
      'description': booking.description,
      'additionalDetails': booking.additionalDetails,
    });
  }

  Future<bool> doesBookingExist(DateTime dateTime) async {
    DateTime _start = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, 0);
    DateTime _end = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, 59);

    // Firebase stores dates as TimeStamp object types which cannot handle being compared with isEqual in a .where
    // This is the only workaround I could find online
    var response = await bookingCollection.where('dateTime', isGreaterThanOrEqualTo: _start).where('dateTime', isLessThanOrEqualTo: _end).get();
    return response.docs.map(_bookingDataFromSnapshot).toList().length > 0;
  }
}