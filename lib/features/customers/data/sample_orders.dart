import '../domain/entities/order.dart';

final sampleOrders = <Order>[
  Order(
    reference: 'ORD-9281',
    customerName: 'Acme Groceries Ltd.',
    placedAt: DateTime(2026, 10, 24),
    itemCount: 3,
    total: 412.50,
    status: OrderStatus.submitted,
  ),
  Order(
    reference: 'ORD-8911',
    customerName: 'Acme Groceries Ltd.',
    placedAt: DateTime(2026, 10, 10),
    itemCount: 5,
    total: 829.00,
    status: OrderStatus.submitted,
  ),
  Order(
    reference: 'ORD-7622',
    customerName: 'Acme Groceries Ltd.',
    placedAt: DateTime(2026, 9, 28),
    itemCount: 2,
    total: 1240.00,
    status: OrderStatus.pending,
  ),
];
