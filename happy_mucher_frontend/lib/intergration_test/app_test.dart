import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../pages/homepage.dart' as app;
import '../pages/inventory.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('tap on the button', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify buttons on homepage
      expect(find.text("View Grocery List"), findsOneWidget);
      expect(find.text("View Inventory"), findsOneWidget);
      expect(find.text("Create Your Budget"), findsOneWidget);

      // Finds the floating action button to tap on.

      // Trigger a frame.

      await tester.pumpAndSettle();
    });
  });
}
