import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_pal/design/components/app_badge.dart';
import 'package:sales_pal/design/theme.dart';
import 'package:sales_pal/features/orders/presentation/pages/order_submission_status_page.dart';

Future<void> _pump(
  WidgetTester tester,
  OrderSubmissionStatus status, {
  VoidCallback? onSaveAsPending,
  VoidCallback? onRetry,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: OrderSubmissionStatusPage(
        status: status,
        onSaveAsPending: onSaveAsPending,
        onRetry: onRetry,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('succeeded', () {
    testWidgets('reports the order reference and a single way onward', (
      tester,
    ) async {
      await _pump(tester, OrderSubmissionStatus.succeeded);

      expect(find.text('Order Submitted!'), findsOneWidget);
      expect(find.text('ORDER #FF-2026-9042'), findsOneWidget);
      expect(find.byType(AppBadge), findsOneWidget);
      expect(find.text('Back to Customers'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      expect(find.text('Save as Pending'), findsNothing);
    });

    testWidgets('draws the heading in the primary colour', (tester) async {
      await _pump(tester, OrderSubmissionStatus.succeeded);

      final heading = tester.widget<Text>(find.text('Order Submitted!'));

      expect(heading.style?.color, AppTheme.light.colorScheme.primary);
    });
  });

  group('failed', () {
    testWidgets('offers both recovery actions and no reference', (
      tester,
    ) async {
      await _pump(tester, OrderSubmissionStatus.failed);

      expect(find.text('Submission Failed'), findsOneWidget);
      expect(find.byType(AppBadge), findsNothing);
      expect(find.text('Save as Pending'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Back to Customers'), findsNothing);
    });

    testWidgets('draws the heading in the error colour', (tester) async {
      await _pump(tester, OrderSubmissionStatus.failed);

      final heading = tester.widget<Text>(find.text('Submission Failed'));

      expect(heading.style?.color, AppTheme.light.colorScheme.error);
    });

    testWidgets('both actions are disabled until step 3 supplies them', (
      tester,
    ) async {
      await _pump(tester, OrderSubmissionStatus.failed);

      for (final label in ['Save as Pending', 'Retry']) {
        final button = tester.widget<OutlinedButton>(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(OutlinedButton),
          ),
        );

        expect(button.onPressed, isNull, reason: '$label should be disabled');
      }
    });

    testWidgets('invokes the callbacks it is given', (tester) async {
      var saved = 0;
      var retried = 0;

      await _pump(
        tester,
        OrderSubmissionStatus.failed,
        onSaveAsPending: () => saved++,
        onRetry: () => retried++,
      );

      await tester.tap(find.text('Save as Pending'));
      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(saved, 1);
      expect(retried, 1);
    });
  });
}
