import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/screens/home/admin_provider.dart';
import 'package:anthonybookings/screens/home/user_customer.dart';
import 'package:anthonybookings/services/auth.dart';
import 'package:anthonybookings/services/user.service.dart';
import 'package:anthonybookings/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BookingUser>(context);

    return StreamBuilder<BookingUser>(
        stream: UserService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            BookingUser user = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                title: Text('Bookings - ${user.isAdmin > 0 ? 'Admin' : 'User'}'),
                actions: [
                  FlatButton.icon(
                    key: ValueKey('signOutButton'),
                    icon: Icon(Icons.person),
                    label: Text('Logout'),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
              body: user.isAdmin > 0 ? AdminProvider(user: user) : UserCustomer(user: user)
            );
          } else {
            return Loading();
          }
        },
    );
  }
}
