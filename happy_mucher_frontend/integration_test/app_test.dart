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

      final homeButton = find.byKey(const Key('home'));
      final toRB = find.byKey(const Key('rb'));
      final dots = find.byKey(const Key('dots'));
      final info = find.byKey(const Key('info'));

      await tester.tap(homeButton);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(toRB, 500.0);
      expect(find.byKey(Key('toRecipeBook')), findsOneWidget);

      //await tester.pump(new Duration(milliseconds: 500));

      await tester.tap(toRB);
      //await tester.pumpAndSettle();
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      //expect(find.byType(SearchWidget), findsOneWidget);
      //expect(find.byKey(Key('search')), findsOneWidget);

      // await tester.tap(dots);
      // await tester.pumpAndSettle();

      // await tester.tap(info);
      // await tester.pumpAndSettle();
    });
  });
}
