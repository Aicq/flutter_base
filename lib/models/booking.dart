class Booking {
  String reference;
  String customerId; // The user that is making the booking
  String providerId; // Who/what is providing the service
  DateTime dateTime; // When
  String description; // Description of booking
  String additionalDetails;

  Booking({this.reference, this.customerId, this.providerId, this.dateTime, this.description, this.additionalDetails});

}