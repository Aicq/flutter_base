class BookingUser {

  String uid;
  String email;
  String password;
  String firstName;
  String lastName;
  int isAdmin;

  BookingUser({this.uid, this.email, this.password, this.isAdmin, this.firstName, this.lastName});

  // These 2 overrides are required to make pre-populating a dropdown work, as even if 2 BookingUser objects
  // have the exact same properties, dart will still equate User1 == User2 to false (which is a check done by
  // DropdownButtonFormField to ensure the value provided exists in the item list)
  // https://stackoverflow.com/questions/60510150/flutter-there-should-be-exactly-one-item-with-dropdownbuttons-value 2nd Answer
  @override
  bool operator ==(Object other) => other is BookingUser && other.uid == uid;
  @override
  int get hashCode => uid.hashCode;
}

