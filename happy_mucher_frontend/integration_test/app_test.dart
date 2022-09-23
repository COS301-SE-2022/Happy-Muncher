import 'package:flutter_test/flutter_test.dart';
import 'package:happy_mucher_frontend/search_widget.dart';
import 'package:integration_test/integration_test.dart';
import 'package:happy_mucher_frontend/main.dart' as app;
import 'package:flutter/material.dart';

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

      await tester.enterText(emailField, 'codeblooded301@gmail.com');
      await tester.pumpAndSettle();

      await tester.tap(passwordField);
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'cos301');
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.widget(find.byType(AppBar));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_forward_outlined));
      await tester.pumpAndSettle();

      // in grcoery list page
      await tester.tap(find.byKey(Key('speed_dial_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('speed_dial_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Inventory'));
      await tester.pumpAndSettle();

      //in budget page
      await tester.tap(find.text('Budget'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('January')));
      await tester.pumpAndSettle();

      /*await tester.tap(find.byIcon(Icons.dashboard));
      await tester.pumpAndSettle();*/
      await tester.tap(find.byKey(Key('editBudget')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('enterBudget')), "500");
      await tester.pumpAndSettle();

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pump();

      await tester.tap(find.text('Meal-Plan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Recipe book'));
      await tester.pumpAndSettle();
      /*await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();*/

      //expect(GLbutton, findsOneWidget);
      // await tester.tap(GLbutton);
      // await tester.pumpAndSettle(const Duration(milliseconds: 500));
    });
  });
}
