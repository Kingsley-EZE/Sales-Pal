import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/error/failure.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_queue_cubit.dart';

import '../../../../support/fake_order_repository.dart';

Order _order(
  String reference, {
  OrderStatus status = OrderStatus.pending,
  String customerId = 'CUS-001',
}) => Order(
  reference: reference,
  customerId: customerId,
  customerName: 'Acme Groceries Ltd.',
  placedAt: DateTime(2026, 8, 24),
  status: status,
  lines: const [
    OrderLineItem(
      productId: 'PRD-001',
      productName: 'Organic Premium Roast Coffee (1kg)',
      unitPrice: 24.50,
      quantity: 2,
    ),
  ],
);

void main() {
  late FakeOrderRepository repository;
  late OrderQueueCubit cubit;

  setUp(() {
    repository = FakeOrderRepository()
      ..stored = [
        _order('PENDING-1'),
        _order('PENDING-2'),
        _order('SENT-1', status: OrderStatus.submitted),
      ];
    cubit = OrderQueueCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  group('load', () {
    test('splits the queue by status', () async {
      await cubit.load();

      final state = cubit.state as OrderQueueLoaded;
      expect(state.pending.map((order) => order.reference), [
        'PENDING-1',
        'PENDING-2',
      ]);
      expect(state.submitted.map((order) => order.reference), ['SENT-1']);
      expect(state.tab, OrderQueueTab.pending);
    });

    test('reports a failed read', () async {
      repository.readFailure = const DataFailure('nope');

      await cubit.load();

      expect(cubit.state, isA<OrderQueueFailed>());
    });

    test('a refresh keeps the tab and the open card', () async {
      await cubit.load();
      cubit
        ..selectTab(OrderQueueTab.submitted)
        ..toggleExpanded(_order('SENT-1', status: OrderStatus.submitted));

      await cubit.load();

      final state = cubit.state as OrderQueueLoaded;
      expect(state.tab, OrderQueueTab.submitted);
      expect(state.expandedReference, 'SENT-1');
    });
  });

  group('tabs and expansion', () {
    test('visible follows the selected tab', () async {
      await cubit.load();

      expect((cubit.state as OrderQueueLoaded).visible, hasLength(2));

      cubit.selectTab(OrderQueueTab.submitted);

      expect((cubit.state as OrderQueueLoaded).visible, hasLength(1));
    });

    test('switching tabs closes the card left behind', () async {
      await cubit.load();
      cubit
        ..toggleExpanded(_order('PENDING-1'))
        ..selectTab(OrderQueueTab.submitted);

      expect((cubit.state as OrderQueueLoaded).expandedReference, isNull);
    });

    test('only one card is open at a time', () async {
      await cubit.load();

      cubit.toggleExpanded(_order('PENDING-1'));
      expect((cubit.state as OrderQueueLoaded).expandedReference, 'PENDING-1');

      cubit.toggleExpanded(_order('PENDING-2'));
      expect((cubit.state as OrderQueueLoaded).expandedReference, 'PENDING-2');
    });

    test('tapping the open card closes it', () async {
      await cubit.load();

      cubit
        ..toggleExpanded(_order('PENDING-1'))
        ..toggleExpanded(_order('PENDING-1'));

      expect((cubit.state as OrderQueueLoaded).expandedReference, isNull);
    });
  });

  group('retry', () {
    test('moves the order to submitted when it goes through', () async {
      await cubit.load();

      await cubit.retry(_order('PENDING-1'));

      final state = cubit.state as OrderQueueLoaded;
      expect(state.pending.map((order) => order.reference), ['PENDING-2']);
      expect(state.submitted.map((order) => order.reference), {
        'SENT-1',
        'PENDING-1',
      });
      expect(state.retryingReference, isNull);
    });

    test('leaves it pending and says why when it fails', () async {
      await cubit.load();
      repository.submitFailure = const OfflineFailure('Still offline.');

      await cubit.retry(_order('PENDING-1'));

      final state = cubit.state as OrderQueueLoaded;
      expect(state.pending.map((order) => order.reference), [
        'PENDING-1',
        'PENDING-2',
      ]);
      expect(state.retryFailureMessage, 'Still offline.');
      expect(state.retryingReference, isNull);
    });

    test('marks the card busy while it is in flight', () async {
      await cubit.load();

      final inFlight = cubit.retry(_order('PENDING-1'));

      expect(
        (cubit.state as OrderQueueLoaded).retryingReference,
        'PENDING-1',
      );

      await inFlight;
    });

    test('clearRetryFailure drops the message once it has been shown', () async {
      await cubit.load();
      repository.submitFailure = const OfflineFailure();
      await cubit.retry(_order('PENDING-1'));

      cubit.clearRetryFailure();

      expect((cubit.state as OrderQueueLoaded).retryFailureMessage, isNull);
    });
  });

  test('a write elsewhere refreshes the queue', () async {
    await cubit.load();
    expect((cubit.state as OrderQueueLoaded).pending, hasLength(2));

    await repository.saveAsPending(_order('PENDING-3'));
    await Future<void>.delayed(Duration.zero);

    expect((cubit.state as OrderQueueLoaded).pending, hasLength(3));
  });
}
