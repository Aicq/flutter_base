import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create brewuser obj based on Firebase user
  BookingUser _userFromFirebaseUser(User user) {
    return user != null ? BookingUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<BookingUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
//  Future signInAnon() async {
//    try {
//      UserCredential result = await _auth.signInAnonymously();
//      // Firebase user
//      User user = result.user;
//      return _userFromFirebaseUser(user);
//    } catch(e) {
//      print(e.toString());
//      return null;
//    }
//  }

  // sign in with email/password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Firebase user id
      return result.user.uid;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email/password
  Future registerWithEmailAndPassword(BookingUser newUser) async {
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(email: newUser.email, password: newUser.password);
        // Booking user - extract uid from firebase user result
        BookingUser user = BookingUser(
            uid: result.user.uid,
            email: newUser.email,
            password: newUser.password,
            firstName: newUser.firstName,
            lastName: newUser.lastName,
            isAdmin: 0
        );

        print('User: ${user.firstName}');

        await UserService(uid: user.uid).updateUserData(user);
        return user;
      } catch(e) {
        print(e.toString());
        return null;
      }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}