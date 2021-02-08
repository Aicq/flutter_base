import 'package:anthonybookings/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  // collection reference
  final CollectionReference bookingCollection = FirebaseFirestore.instance.collection('bookings');

  // userData from snapshot
  Booking _bookingDataFromSnapshot(dynamic snapshot) {
    return Booking(
      id: snapshot.data()['id'],
      customerId: snapshot.data()['customerId'],
      providerId: snapshot.data()['providerId'],
      dateTime: snapshot.data()['dateTime'].toDate(),
      description: snapshot.data()['description'],
      additionalDetails: snapshot.data()['additionalDetails'],
    );
  }

  // Used to add/update a user
  Future addEditBooking(Booking booking) async {
    try {
      if (booking.id == null) {
        await bookingCollection.add({
          'customerId': booking.customerId,
          'providerId': booking.providerId,
          'dateTime': booking.dateTime,
          'description': booking.description,
          'additionalDetails': booking.additionalDetails,
        }).then((docRef) async {
          // Also add the firebase-generated id as a field
          await bookingCollection.doc(docRef.id).update({
            'id': docRef.id,
          });
        });
      } else {
        await bookingCollection.doc(booking.id).update({
          'customerId': booking.customerId,
          'providerId': booking.providerId,
          'dateTime': booking.dateTime,
          'description': booking.description,
          'additionalDetails': booking.additionalDetails,
        });
      }

      return true;
    } catch(e) {
      print(e.toString());
      return null;
    }

  }

  // Retrieves all bookings for a specified day
  Future<List<Booking>> getBookingsOnDay(DateTime dateTime) async {
    DateTime _start = DateTime(dateTime.year, dateTime.month, dateTime.day, 0);
    DateTime _end = DateTime(dateTime.year, dateTime.month, dateTime.day, 23);

    // Firebase stores dates as TimeStamp object types which cannot handle being compared with isEqual in a .where
    // This is the only workaround I could find online
    var response = await bookingCollection.where('dateTime', isGreaterThanOrEqualTo: _start).where('dateTime', isLessThanOrEqualTo: _end).get();
    return response.docs.map(_bookingDataFromSnapshot).toList();
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    // This query relies on an index created on firebase
    var response = await bookingCollection.where('customerId', isEqualTo: userId).orderBy('dateTime').get();
    return response.docs.map(_bookingDataFromSnapshot).toList();
  }

  // Retrieves a provider's bookings for a specific day
  Future<List<Booking>> getProviderBookings(String userId, DateTime dateTime) async {
    DateTime _start = DateTime(dateTime.year, dateTime.month, dateTime.day, 0);
    DateTime _end = DateTime(dateTime.year, dateTime.month, dateTime.day, 23);
    // This query relies on an index created on firebase
    var response = await bookingCollection
        .where('providerId', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: _start)
        .where('dateTime', isLessThanOrEqualTo: _end)
        .orderBy('dateTime').get();
    return response.docs.map(_bookingDataFromSnapshot).toList();
  }

  void removeBooking(String bookingId) async {
    await bookingCollection.doc(bookingId).delete().then((_) {
      print('Document successfully deleted!');
    });
  }
}