import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/error/failure.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sales_pal/features/orders/presentation/cubit/submit_order_cubit.dart';

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
  late FakeOrderRepository repository;
  late SubmitOrderCubit cubit;

  setUp(() {
    repository = FakeOrderRepository();
    cubit = SubmitOrderCubit(repository);
  });

  tearDown(() => cubit.close());

  Future<void> submit() => cubit.submit(
    customerId: 'CUS-001',
    customerName: 'Acme Groceries Ltd.',
    lines: _lines,
  );

  group('SubmitOrderCubit', () {
    test('starts idle', () => expect(cubit.state, const SubmitOrderIdle()));

    test('reports progress then success', () async {
      final states = expectLater(
        cubit.stream,
        emitsInOrder([
          const SubmitOrderInProgress(),
          isA<SubmitOrderSucceeded>(),
        ]),
      );

      await submit();
      await states;
    });

    test('mints a reference before the attempt', () async {
      await submit();

      expect(repository.submitted.single.reference, isNotEmpty);
      expect(repository.submitted.single.status, OrderStatus.pending);
    });

    test('builds the order from the arguments it was given', () async {
      await submit();

      final order = repository.submitted.single;

      expect(order.customerId, 'CUS-001');
      expect(order.customerName, 'Acme Groceries Ltd.');
      expect(order.lines, _lines);
      expect(order.total, 49.00);
    });

    test('keeps the order alongside the failure', () async {
      repository.submitFailure = const OfflineFailure();

      await submit();

      final state = cubit.state as SubmitOrderFailed;
      expect(state.failure, isA<OfflineFailure>());
      expect(state.order.lines, _lines);
    });

    test('retry re-sends the same order rather than a new one', () async {
      repository.submitFailure = const OfflineFailure();
      await submit();

      final reference = (cubit.state as SubmitOrderFailed).order.reference;
      repository.submitFailure = null;
      await cubit.retry();

      expect(repository.submitted, hasLength(2));
      expect(repository.submitted.last.reference, reference);
      expect(cubit.state, isA<SubmitOrderSucceeded>());
    });

    test('retry does nothing when there is no failed order', () async {
      await cubit.retry();

      expect(repository.submitted, isEmpty);
      expect(cubit.state, const SubmitOrderIdle());
    });

    test('saveAsPending writes the failed order', () async {
      repository.submitFailure = const OfflineFailure();
      await submit();

      await cubit.saveAsPending();

      expect(repository.saved.single.reference, isNotEmpty);
      expect(repository.saved.single.lines, _lines);
    });

    test('saveAsPending writes nothing after a success', () async {
      await submit();

      await cubit.saveAsPending();

      expect(repository.saved, isEmpty);
    });

    test('a failed save surfaces its own failure', () async {
      repository.submitFailure = const OfflineFailure();
      await submit();

      repository.saveFailure = const DataFailure('Could not save this order.');
      await cubit.saveAsPending();

      final state = cubit.state as SubmitOrderFailed;
      expect(state.failure, isA<DataFailure>());
      expect(state.failure.message, 'Could not save this order.');
    });

    test('reset returns to idle', () async {
      await submit();

      cubit.reset();

      expect(cubit.state, const SubmitOrderIdle());
    });
  });
}
