// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final emailField = find.byValueKey('email');
    final passwordField = find.byValueKey('password');

    final loginButton = find.byValueKey('loginButton');
    final signOutButton = find.byValueKey('signOutButton');

    FlutterDriver driver;

    // Checks if certain widgets are present
    Future<bool> isPresent(SerializableFinder byValueKey, {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(byValueKey, timeout: timeout);
        return true;
      } catch (exception) {
        return false;
      }
    }

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('login', () async {
      //check if there is a sign out button present.
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }

      await driver.tap(emailField);
      await driver.enterText('a@a.com');
      await driver.tap(passwordField);
      await driver.enterText('123456');

      await driver.tap(loginButton);
      await driver.waitFor(find.text('Welcome Jim!'));
    });

    test('signout', () async {
      //check if there is a sign out button present.
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }
    });
//
//    test('create account', () async {
//
//    });

  });
}
