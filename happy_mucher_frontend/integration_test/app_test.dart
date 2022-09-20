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

      await tester.enterText(emailField, 'u20554240@tuks.co.za');
      await tester.pumpAndSettle();

      await tester.tap(passwordField);
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(Key('Meal Planner')));
      await tester.pumpAndSettle();

      /*await tester.tap(find.byKey(Key('NavButton')));
      await tester.pumpAndSettle();*/

      //expect(GLbutton, findsOneWidget);
      // await tester.tap(GLbutton);
      // await tester.pumpAndSettle(const Duration(milliseconds: 500));
    });
  });
}
