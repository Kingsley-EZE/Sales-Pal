import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_pal/core/error/failure.dart';
import 'package:sales_pal/design/components/app_badge.dart';
import 'package:sales_pal/design/theme.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
import 'package:sales_pal/features/orders/presentation/cubit/submit_order_cubit.dart';
import 'package:sales_pal/features/orders/presentation/pages/order_submission_status_page.dart';

import '../../../../support/fake_order_repository.dart';

const _lines = [
  OrderLineItem(
    productId: 'PRD-001',
    productName: 'Organic Premium Roast Coffee (1kg)',
    unitPrice: 24.50,
    quantity: 2,
  ),
];

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  late FakeOrderRepository repository;
  late SubmitOrderCubit submission;
  late OrderDraftCubit draft;

  setUp(() {
    repository = FakeOrderRepository();
    submission = SubmitOrderCubit(repository);
    draft = OrderDraftCubit();
  });

  tearDown(() async {
    await submission.close();
    await draft.close();
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: submission),
          BlocProvider.value(value: draft),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const OrderSubmissionStatusPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> submit() => submission.submit(
    customerId: 'CUS-001',
    customerName: 'Acme Groceries Ltd.',
    lines: _lines,
  );

  group('succeeded', () {
    testWidgets('reports the reference the order was sent under', (
      tester,
    ) async {
      await submit();
      await pump(tester);

      final reference = repository.submitted.single.reference;

      expect(find.text('Order Submitted!'), findsOneWidget);
      expect(find.text('ORDER #$reference'), findsOneWidget);
      expect(find.byType(AppBadge), findsOneWidget);
      expect(find.text('Back to Customers'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      expect(find.text('Save as Pending'), findsNothing);
    });

    testWidgets('draws the heading in the primary colour', (tester) async {
      await submit();
      await pump(tester);

      final heading = tester.widget<Text>(find.text('Order Submitted!'));

      expect(heading.style?.color, AppTheme.light.colorScheme.primary);
    });
  });

  group('failed', () {
    testWidgets('offers both recovery actions and no reference', (
      tester,
    ) async {
      repository.submitFailure = const OfflineFailure();
      await submit();
      await pump(tester);

      expect(find.text('Submission Failed'), findsOneWidget);
      expect(find.byType(AppBadge), findsNothing);
      expect(find.text('Save as Pending'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Back to Customers'), findsNothing);
    });

    testWidgets('draws the heading in the error colour', (tester) async {
      repository.submitFailure = const OfflineFailure();
      await submit();
      await pump(tester);

      final heading = tester.widget<Text>(find.text('Submission Failed'));

      expect(heading.style?.color, AppTheme.light.colorScheme.error);
    });

    testWidgets('explains the failure it was actually given', (tester) async {
      repository.submitFailure = const DataFailure('The server said no.');
      await submit();
      await pump(tester);

      expect(find.text('The server said no.'), findsOneWidget);
      expect(find.textContaining('currently offline'), findsNothing);
    });

    testWidgets('Retry re-sends the same order', (tester) async {
      repository.submitFailure = const OfflineFailure();
      await submit();
      await pump(tester);

      final reference = repository.submitted.single.reference;
      repository.submitFailure = null;

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(repository.submitted, hasLength(2));
      expect(repository.submitted.last.reference, reference);
      expect(find.text('Order Submitted!'), findsOneWidget);
    });
  });

  testWidgets('shows nothing when nothing has been submitted', (tester) async {
    await pump(tester);

    expect(find.byType(Scaffold), findsNothing);
    expect(find.text('Order Submitted!'), findsNothing);
    expect(find.text('Submission Failed'), findsNothing);
  });
}
