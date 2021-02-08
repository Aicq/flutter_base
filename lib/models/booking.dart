class Booking {
  String id;
  String customerId; // The user that is making the booking
  String providerId; // Who/what is providing the service
  DateTime dateTime; // When
  String description; // Description of booking
  String additionalDetails;

  Booking({this.id, this.customerId, this.providerId, this.dateTime, this.description, this.additionalDetails});

}