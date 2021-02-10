import 'package:anthonybookings/screens/menu/menu_options/user_profile.dart';
import 'package:anthonybookings/shared/themes.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: Drawer(
        child: Column(
          children: [
            AppBar(
              title: Text('Menu'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('User Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
              },
            ),
            ListTile(
              leading: Theme.of(context).brightness == Brightness.dark ? Icon(Icons.nights_stay) : Icon(Icons.wb_sunny),
              title: Text('Toggle Theme'),
              onTap: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
                DynamicTheme.of(context).setThemeData(
                    Theme.of(context).brightness == Brightness.dark
                    ? getLightTheme(Brightness.light)
                    : getDarkTheme(Brightness.dark));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('FAQ'),
              onTap: () {
                print('yoyo');
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('About Us'),
              onTap: () {
                print('yoyo');
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contact Us'),
              onTap: () {
                print('yoyo');
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Our Location'),
              onTap: () {
                print('yoyo');
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Report a Bug'),
              onTap: () {
                print('yoyo');
              },
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.all(10.0),
                color: Theme.of(context).accentColor,
                child: Text(
                    'Developed in Flutter by Anthony Crossland 2021',
                    textAlign: TextAlign.center
                )
            )
          ],
        ),
      ),
    );
  }
}
