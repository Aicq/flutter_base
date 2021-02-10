import 'package:anthonybookings/models/booking.dart';
import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/screens/home/admin_provider.dart';
import 'package:anthonybookings/screens/home/user_customer.dart';
import 'package:anthonybookings/screens/menu/menu.dart';
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
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () { Scaffold.of(context).openDrawer(); },
                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    );
                  },
                ),
                actions: [
                  FlatButton.icon(
                    key: ValueKey('signOutButton'),
                    icon: Icon(Icons.person, color: Colors.white),
                    label: Text('Logout', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
              drawer: SideMenu(),
              // The user is passed to these widgets (instead of using provider) as it is needed in initState while also being listened to
              body: user.isAdmin > 0 ? AdminProvider(user: user) : UserCustomer(user: user)
            );
          } else {
            return Loading();
          }
        },
    );
  }
}
