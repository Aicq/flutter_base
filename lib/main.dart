import 'package:anthonybookings/screens/home/home.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:anthonybookings/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<BookingUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          buttonColor: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: Wrapper(),
      ),
    );
  }
}

