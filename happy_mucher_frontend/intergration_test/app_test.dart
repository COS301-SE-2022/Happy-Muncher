// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Happy Muncher', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    //login screen / sign up screen
    final emailField = find.byValueKey('Email');
    final passwordField = find.byValueKey('Password');
    final confirmField = find.byValueKey('Confirm Password');
    final signInButton = find.byValueKey('Submit');

    //home screen
    /*final signOutButton = find.byValueKey('signOut');
    final addField = find.byValueKey('addField');
    final addButton = find.byValueKey('addButton');*/

    /*FlutterDriver driver;

    Future<bool> isPresent(SerializableFinder byValueKey,
        {Duration timeout = const Duration(seconds: 1)}) async {
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
    });*/

    // Close the connection to the driver after the tests have completed.
    /*tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('create account', () async {
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }

      await driver.tap(usernameField);
      await driver.enterText("u20554240@tuks.co.za");

      await driver.tap(passwordField);
      await driver.enterText("123456");

      await driver.tap(createAccountButton);
      await driver.waitFor(find.text("Your Todos"));
    });*/

    /*test('login', () async {
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }

      await driver.tap(usernameField);
      await driver.enterText("u20554240@tuks.co.za");

      await driver.tap(passwordField);
      await driver.enterText("123456");

      await driver.tap(signInButton);
      await driver.waitFor(find.text("Your Todos"));
    });

    test('add a todo', () async {
      if (await isPresent(signOutButton)) {
        await driver.tap(addField);
        await driver.enterText("make an integration test video");
        await driver.tap(addButton);

        await driver.waitFor(find.text("make an integration test video"),
            timeout: const Duration(seconds: 3));
      }
    });*/
  });
}
