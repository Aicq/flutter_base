import 'package:flutter_driver/driver_extension.dart';
import 'package:anthonybookings/main.dart' as app;

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the 'main()' function of the app, or call any widget you are interested
  // in testing.
  app.main();
}