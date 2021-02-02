import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/screens/home/home.dart';
import 'package:anthonybookings/screens/login/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // These lines are the same:
    // final user = Provider.of<BookingUser>(context);
    final user = context.watch<BookingUser>();

    print('My USER: ${user?.firstName}');

    // return home or authenticate widget
    return user == null ? Authenticate() : Home();
  }
}
