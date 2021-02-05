import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // Default
   final FirebaseAuth auth = FirebaseAuth.instance;
  // For running unit test
  //  FirebaseAuth auth;
  //  AuthService({this.auth});

  // create brewuser obj based on Firebase user
  BookingUser _userFromFirebaseUser(User user) {
    return user != null ? BookingUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<BookingUser> get user {
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
//  Future signInAnon() async {
//    try {
//      UserCredential result = await auth.signInAnonymously();
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
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      // Firebase user id
//      return result.user.uid;
      return true;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email/password
  Future registerWithEmailAndPassword(BookingUser newUser) async {
      try {
        UserCredential result = await auth.createUserWithEmailAndPassword(email: newUser.email, password: newUser.password);
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
        return true;
      } catch(e) {
        print(e.toString());
        return null;
      }
  }

  // sign out
  Future signOut() async {
    try {
      await auth.signOut();
      return true;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}