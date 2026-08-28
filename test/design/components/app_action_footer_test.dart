import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_button.dart';
import 'package:sales_pal/design/theme.dart';

Future<void> _pump(WidgetTester tester, Widget footer) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(bottomNavigationBar: footer),
  ),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('AppActionFooter', () {
    testWidgets('renders a primary action above a secondary one', (
      tester,
    ) async {
      await _pump(
        tester,
        AppActionFooter(
          primary: AppAction(label: 'Submit Order', onPressed: () {}),
          secondary: AppAction(label: 'Edit Order', onPressed: () {}),
        ),
      );

      expect(find.byType(AppButton), findsNWidgets(2));

      final submit = tester.getRect(find.text('Submit Order'));
      final edit = tester.getRect(find.text('Edit Order'));
      expect(submit.top, lessThan(edit.top));
    });

    testWidgets('omits the secondary button when no action is given', (
      tester,
    ) async {
      await _pump(
        tester,
        AppActionFooter(
          primary: AppAction(label: 'Save as Pending', onPressed: () {}),
        ),
      );

      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Save as Pending'), findsOneWidget);
    });

    testWidgets('places the leading slot above the buttons', (tester) async {
      await _pump(
        tester,
        AppActionFooter(
          leading: const Text('Order Subtotal'),
          primary: AppAction(label: 'Review Order', onPressed: () {}),
        ),
      );

      final subtotal = tester.getRect(find.text('Order Subtotal'));
      final review = tester.getRect(find.text('Review Order'));
      expect(subtotal.top, lessThan(review.top));
    });

    testWidgets('stretches both buttons to the same width', (tester) async {
      await _pump(
        tester,
        AppActionFooter(
          primary: AppAction(label: 'Submit Order', onPressed: () {}),
          secondary: AppAction(label: 'Edit', onPressed: () {}),
        ),
      );

      final buttons = tester
          .widgetList<AppButton>(find.byType(AppButton))
          .toList();
      final widths = buttons
          .map((button) => tester.getSize(find.byWidget(button)).width)
          .toSet();

      expect(widths, hasLength(1));
    });

    testWidgets('forwards taps to each action', (tester) async {
      var submitted = 0;
      var edited = 0;

      await _pump(
        tester,
        AppActionFooter(
          primary: AppAction(label: 'Submit Order', onPressed: () => submitted++),
          secondary: AppAction(label: 'Edit Order', onPressed: () => edited++),
        ),
      );

      await tester.tap(find.text('Submit Order'));
      await tester.tap(find.text('Edit Order'));
      await tester.pump();

      expect(submitted, 1);
      expect(edited, 1);
    });
  });
}
