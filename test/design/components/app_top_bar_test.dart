import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/theme.dart';

void main() {
  Future<void> pumpTopBar(WidgetTester tester, AppTopBar topBar) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(appBar: topBar, body: const SizedBox.shrink()),
      ),
    );
  }

  group('AppTopBar', () {
    testWidgets('renders title only by default', (tester) async {
      await pumpTopBar(tester, const AppTopBar(title: 'Customers'));

      expect(find.text('Customers'), findsOneWidget);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('renders subtitle and back button when provided', (
      tester,
    ) async {
      await pumpTopBar(
        tester,
        const AppTopBar(
          title: 'Acme Groceries Ltd.',
          subtitle: 'Downtown Outlet',
          showBackButton: true,
        ),
      );

      expect(find.text('Acme Groceries Ltd.'), findsOneWidget);
      expect(find.text('Downtown Outlet'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('back button invokes onBack', (tester) async {
      var pressed = false;
      await pumpTopBar(
        tester,
        AppTopBar(
          title: 'Acme Groceries Ltd.',
          showBackButton: true,
          onBack: () => pressed = true,
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(pressed, isTrue);
    });

    testWidgets('is taller when a subtitle is present', (tester) async {
      const withSubtitle = AppTopBar(title: 'Acme', subtitle: 'Downtown');
      const withoutSubtitle = AppTopBar(title: 'Acme');

      expect(
        withSubtitle.preferredSize.height,
        greaterThan(withoutSubtitle.preferredSize.height),
      );
    });
  });
}
