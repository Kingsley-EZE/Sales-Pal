import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/error/failure.dart';
import 'package:sales_pal/features/customers/presentation/cubit/customer_orders_cubit.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';

import '../../../../support/fake_order_repository.dart';

Order _order(String reference, {String customerId = 'CUS-001'}) => Order(
  reference: reference,
  customerId: customerId,
  customerName: 'Acme Groceries Ltd.',
  placedAt: DateTime(2026, 8, 24),
  status: OrderStatus.submitted,
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
  late CustomerOrdersCubit cubit;

  setUp(() {
    repository = FakeOrderRepository()
      ..stored = [
        _order('MINE-1'),
        _order('MINE-2'),
        _order('THEIRS', customerId: 'CUS-002'),
      ];
    cubit = CustomerOrdersCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('starts loading', () {
    expect(cubit.state, const CustomerOrdersLoading());
  });

  test('loads only this customer’s orders', () async {
    await cubit.load('CUS-001');

    final state = cubit.state as CustomerOrdersLoaded;
    expect(state.orders.map((order) => order.reference), ['MINE-1', 'MINE-2']);
  });

  test('a customer with no history loads empty rather than failing', () async {
    await cubit.load('CUS-999');

    expect((cubit.state as CustomerOrdersLoaded).orders, isEmpty);
  });

  test('reports a failed read', () async {
    repository.readFailure = const DataFailure('Could not load orders.');

    await cubit.load('CUS-001');

    final state = cubit.state as CustomerOrdersFailed;
    expect(state.message, 'Could not load orders.');
  });

  test('picks up an order placed while the page is open', () async {
    await cubit.load('CUS-001');
    expect((cubit.state as CustomerOrdersLoaded).orders, hasLength(2));

    await repository.saveAsPending(_order('MINE-3'));
    await Future<void>.delayed(Duration.zero);

    expect((cubit.state as CustomerOrdersLoaded).orders, hasLength(3));
  });

  test('ignores an order placed for somebody else', () async {
    await cubit.load('CUS-001');

    await repository.saveAsPending(_order('THEIRS-2', customerId: 'CUS-002'));
    await Future<void>.delayed(Duration.zero);

    expect((cubit.state as CustomerOrdersLoaded).orders, hasLength(2));
  });
}
