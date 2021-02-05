import 'package:anthonybookings/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockFirebaseUser extends Mock implements User {}

class MockFirebaseAuth extends Mock implements FirebaseAuth{}

class MockAuthResult extends Mock implements UserCredential{}

void main() {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  when(_auth.authStateChanges()).thenAnswer((_) {
    return _user;
  });
  AuthService _authService = AuthService(auth: _auth);

  group('user test', (){
    when(_auth.signInWithEmailAndPassword(email: 'test@email.com', password: '123456')).thenAnswer((_) async {
      _user.add(MockFirebaseUser());
      return MockAuthResult();
    });
    when(_auth.signInWithEmailAndPassword(email: 'test', password: '000000')).thenThrow(() {
      return null;
    });

    test("sign in with email and password", () async {
      bool signedIn = await _authService.signInWithEmailAndPassword('test@email.com', '123456');
      expect(signedIn, true);
    });

    test("sign in fails with incorrect email and password", () async {
      bool signedIn = await _authService.signInWithEmailAndPassword('test', '000000');
      expect(signedIn, null);
    });

    test("sign out", () async {
      bool signedOut = await _authService.signOut();
      expect(signedOut, true);
    });
  });
}