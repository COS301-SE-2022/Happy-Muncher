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
      await tester.pumpAndSettle();

      await tester.tap(passwordField);
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.widget(find.byType(AppBar));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_forward_outlined));
      await tester.pumpAndSettle();

      // in grocery list page
      await tester.tap(find.byKey(Key('speed_dial_button')));
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
      await tester.tap(find.byKey(Key('groceryListDialogAddButton')));
      /*await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile)); */

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      //in inventory page
      await tester.tap(find.byIcon(Icons.receipt_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('inventory_speed_dial_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('addToInventoryButtonText')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('inventoryDialogNameField')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('inventoryDialogNameField')), 'juice');
      await tester.pump();
      await tester.tap(find.byKey(Key('inventoryDialogQuantityField')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('inventoryDialogQuantityField')), '1');
      await tester.pump();
      await tester.tap(find.byKey(Key('inventoryDialogAddButton')));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(find.byIcon(Icons.delete),
          find.byType(SlidableAction), const Offset(-300, 0));
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      //in budget page
      await tester.tap(find.text('Budget'));
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
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.text('Meal-Plan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Recipe book'));
      await tester.pumpAndSettle();

      await tester.widget(find.byType(AppBar));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('Profile')));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      /*await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();*/

      //expect(GLbutton, findsOneWidget);
      // await tester.tap(GLbutton);
      // await tester.pumpAndSettle(const Duration(milliseconds: 500));
    });
  });
}
