import 'package:anthonybookings/screens/menu/menu_options/about_us.dart';
import 'package:anthonybookings/screens/menu/menu_options/bug_report.dart';
import 'package:anthonybookings/screens/menu/menu_options/contact_us.dart';
import 'package:anthonybookings/screens/menu/menu_options/faq.dart';
import 'package:anthonybookings/screens/menu/menu_options/user_profile.dart';
import 'package:anthonybookings/shared/themes.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {

  // Open google maps (in app if user has it) for given location
  void _launchMapsUrl() async {
    final url = 'https://www.google.com/maps/place/In+The+Code/@-28.001455,153.4115303,17z/data=!3m1!4b1!4m5!3m4!1s0x6b91034395cf589d:0x57f608825f825c73!8m2!3d-28.001455!4d153.413719';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Faq()));
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('About Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs()));
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Our Location'),
              onTap: () {
                _launchMapsUrl();
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Report a Bug'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BugReport()));
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
