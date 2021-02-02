import 'package:anthonybookings/models/booking_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});
  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(BookingUser user) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'email': user.email,
      'password': user.password,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'isAdmin': user.isAdmin,
    });
  }
//
//  // get brew list from snapshot
//  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
//    return snapshot.docs.map((doc) {
//      return Brew(
//        name: doc.data()['name'] ?? '',
//        strength: doc.data()['strength'] ?? 0,
//        sugars: doc.data()['sugars'] ?? '0',
//      );
//    }).toList();
//  }
//
  // userData from snapshot
  BookingUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return BookingUser(
      uid: uid,
      email: snapshot.data()['email'],
      firstName: snapshot.data()['firstName'],
      lastName: snapshot.data()['lastName'],
      isAdmin: snapshot.data()['isAdmin'],
    );
  }
//
//  // get brews stream
//  Stream<List<Brew>> get brews {
//    return userCollection.snapshots().map(_brewListFromSnapshot);
//  }
//
  // get user doc stream
  Stream<BookingUser> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get current user doc
  Future<BookingUser> get currentUser async {
    var document = await userCollection.doc(uid);
    print(document);
    return null;
  }

}