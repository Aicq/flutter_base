import 'package:anthonybookings/models/booking_user.dart';
import 'package:anthonybookings/screens/home/booking_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anthonybookings/screens/home/user_customer.dart';
import 'package:mockito/mockito.dart';

class MockBookingUser extends Mock implements BookingUser{}

/**
 * Cant seem to get widget test to work for now since every part of the app uses firebase
 */
void main() {

  testWidgets('Change date', (WidgetTester tester) async {
    MockBookingUser _user = MockBookingUser();
    // Create widget
    await tester.pumpWidget(MaterialApp(home: BookingForm(user: _user,)));
    final textFinder = find.text('Available Bookings - 15/02/21');

    await tester.tap(find.text('15'));

    await tester.pump();

    expect(textFinder, findsOneWidget);
  });

}