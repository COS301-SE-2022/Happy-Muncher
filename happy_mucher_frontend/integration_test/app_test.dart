import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happy_mucher_frontend/search_widget.dart';
import 'package:integration_test/integration_test.dart';
import 'package:happy_mucher_frontend/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  group('happy_muncher test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('full test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('Email'));
      final passwordField = find.byKey(Key('Password'));
      final confirmField = find.byKey(Key('Confirm Password'));
      final submitButton = find.byKey(Key('Submit'));

      final GLbutton = find.byKey(Key("gbutton"));

      final loginPage = find.byWidget(Container());

      await tester.tap(emailField);
      await tester.pumpAndSettle();

      await tester.enterText(emailField, 'u20554240@tuks.co.za');
      //await tester.enterText(emailField, 'codeblooded301@gmail.com');
      await tester.pumpAndSettle();

      await tester.tap(passwordField);
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, '123456');
      //await tester.enterText(passwordField, 'cos301');
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.widget(find.byType(AppBar));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_forward_outlined));
      await tester.pumpAndSettle();

      // in grocery list page
      /*await tester.tap(find.byKey(Key('speed_dial_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('addToInventoryButtonText')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('groceryListDialogNameField')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('groceryListDialogNameField')), 'lettuce');
      await tester.pump();
      await tester.tap(find.byKey(Key('groceryListDialogPriceField')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('groceryListDialogPriceField')), '10');
      await tester.pump();
      await tester.tap(find.byKey(Key('groceryListDialogAddButton')));*/
      /*await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile)); */

      //await tester.pumpAndSettle(const Duration(milliseconds: 500));

      //in inventory page
      await tester.tap(find.byKey(Key('Inventory')));
      await tester.pumpAndSettle();

      /*await tester.tap(find.byKey(Key('addToInventoryButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('addToInventoryButtonText')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('inventoryDialogNameField')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('inventoryDialogNameField')), 'ice cream');
      await tester.pump();
      await tester.tap(find.byKey(Key('inventoryDialogQuantityField')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('inventoryDialogQuantityField')), '1');
      await tester.pump();
      await tester.tap(find.byKey(Key('inventoryDialogAddButton')));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      final NavigatorState nav = tester.state(find.byType(Navigator));
      nav.pop();*/
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      /*await tester.dragUntilVisible(find.byIcon(Icons.delete),
          find.byKey(Key('ice cream')), const Offset(-300, 0));
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));*/

      //in budget page
      await tester.tap(find.byKey(Key('Budget')));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('editBudget')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('enterBudget')), "500");
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('setBudget')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.dragUntilVisible(
          find.byKey(Key('Week1 edit')),
          find.byKey(
            Key('Week1 carousel'),
          ),
          const Offset(500, 0));

      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(Key('Week1 edit')));
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('spent1')), "50");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
          find.text("Compare to Grocery List"),
          find.byKey(
            Key('Week1 carousel'),
          ),
          const Offset(0, -600));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('Compare')));
      await tester.pumpAndSettle();

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pump(const Duration(milliseconds: 500));

      // await tester.tap(find.text('Meal-Plan'));
      //await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('Recipe book')), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Recipe Book'));
      await tester.pumpAndSettle();
      final NavigatorState nav6 = tester.state(find.byType(Navigator));
      nav6.pop();
      /*await tester.pumpAndSettle();
      await tester.tap(find.text('My Favourites'));
      await tester.pumpAndSettle(const Duration(seconds: 15));
      final NavigatorState nav7 = tester.state(find.byType(Navigator));
      nav7.pop();*/
      /*await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(find.text('Tasty Recipe Book'));
      await tester.pumpAndSettle(const Duration(seconds: 10));
      await tester.tapAt(const Offset(379.0, 195.8));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('add')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wednesday'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      //await tester.tap(find.byType(IconButton));//not working

      /*nav2.pop();
      await tester.pumpAndSettle();
      nav2.pop();
      await tester.pumpAndSettle();*/
      /*final NavigatorState nav4 = tester.state(find.byType(Navigator));
      nav4.pop();
      final NavigatorState nav5 = tester.state(find.byType(Navigator));
      nav5.pop();*/
      /*await tester.tap(find.text('My Recipe Book'));
      final NavigatorState nav6 = tester.state(find.byType(Navigator));
      nav6.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Favourites'));
      final NavigatorState nav7 = tester.state(find.byType(Navigator));
      nav7.pop();
      await tester.pumpAndSettle();*/

      await tester.widget(find.byType(AppBar));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.dashboard));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.text('Inventory'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.widget(find.byType(AppBar));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(Key('Profile')));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.text('User'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      final NavigatorState nav8 = tester.state(find.byType(Navigator));
      nav8.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('u20554240@tuks.co.za'));
      await tester.pumpAndSettle();
      final NavigatorState nav9 = tester.state(find.byType(Navigator));
      nav9.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();
      final NavigatorState nav10 = tester.state(find.byType(Navigator));
      nav10.pop();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      final NavigatorState nav11 = tester.state(find.byType(Navigator));
      nav11.pop();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();*/

      /*await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();*/

      //expect(GLbutton, findsOneWidget);
      // await tester.tap(GLbutton);
      // await tester.pumpAndSettle(const Duration(milliseconds: 500));
    });
  });
}
