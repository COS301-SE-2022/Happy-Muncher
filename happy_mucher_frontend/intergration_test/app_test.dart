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
    final submitButton = find.byValueKey('Logout');

    //home screen
    final signOutButton = find.byValueKey('signOut');
    final addField = find.byValueKey('addField');
    final addButton = find.byValueKey('addButton');
    FlutterDriver? driver;

    Future<bool> isPresent(SerializableFinder byValueKey,
        {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver!.waitFor(byValueKey, timeout: timeout);
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
        driver!.close();
      }
    });

    test('login', () async {
      /*if (await isPresent(signOutButton)) {
        await driver!.tap(signOutButton);
      }*/

      await driver!.tap(emailField);
      await driver!.enterText("u20554240@tuks.co.za");

      await driver!.tap(passwordField);
      await driver!.enterText("123456");

      await driver!.tap(submitButton);
      // await driver!.waitFor(find.text("Home"));
    });

    /*test('home page', () async {
      await driver!.tap(find.byValueKey("Grocery List"));
      await driver!.tap(find.pageBack());

      await driver!.tap(find.byValueKey("Inventory"));
      await driver!.tap(find.pageBack());

      await driver!.tap(find.byValueKey("Budget"));
      await driver!.tap(find.pageBack());

      await driver!.tap(find.byValueKey("Meal Planner"));
      await driver!.tap(find.pageBack());

      await driver!.tap(find.byValueKey("toRecipeBook"));
      await driver!.tap(find.pageBack());
    });

    test('nav bar', () async {
      await driver!.tap(find.byType("NavBar"));

      await driver!.tap(find.byType("SettingsPage"));
      await driver!.tap(find.pageBack());

      if (await isPresent(signOutButton)) {
        await driver!.tap(signOutButton);
      }

      /*await driver.tap(signInButton);
      await driver.waitFor(find.text("Your Todos"));*/
    });*/

    /*  test('add a todo', () async {
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
