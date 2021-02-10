import 'package:anthonybookings/models/booking_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

  String uid;
  UserService({this.uid});
  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // Used to update a user
  Future addNewUser(BookingUser user) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'email': user.email,
      'password': user.password,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'imageUrl': user.imageUrl,
      'isAdmin': user.isAdmin,
    });
  }

  // Used to update a user
  Future updateUserData(BookingUser user) async {
    return await userCollection.doc(user.uid).update({
      'email': user.email,
      'password': user.password,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'imageUrl': user.imageUrl,
      'isAdmin': user.isAdmin,
    });
  }

  // userData from snapshot
  BookingUser _userDataFromSnapshot(dynamic snapshot) {
    return BookingUser(
      uid: snapshot.data()['uid'],
      email: snapshot.data()['email'],
      firstName: snapshot.data()['firstName'],
      lastName: snapshot.data()['lastName'],
      imageUrl: snapshot.data()['imageUrl'],
      isAdmin: snapshot.data()['isAdmin'],
    );
  }

  // get current user doc stream
  Stream<BookingUser> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get a specific user doc given id
  Future<BookingUser> singleUser(String userId) async {
     return userCollection.doc(userId).get().then((snapshot) {
       return _userDataFromSnapshot(snapshot);
    });
  }

  Future<List<BookingUser>> fetchUsers(String field, dynamic value) async {
    var response = await userCollection.where(field, isEqualTo: value).get();
    print('DATA: ${_userDataFromSnapshot(response.docs[0])}');
    return response.docs.map(_userDataFromSnapshot).toList();
  }

}