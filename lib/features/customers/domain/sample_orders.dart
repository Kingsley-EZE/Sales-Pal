import 'order.dart';

final sampleOrders = <Order>[
  Order(
    reference: 'ORD-9281',
    placedAt: DateTime(2026, 10, 24),
    total: 412.50,
    status: OrderStatus.submitted,
  ),
  Order(
    reference: 'ORD-8911',
    placedAt: DateTime(2026, 10, 10),
    total: 829.00,
    status: OrderStatus.submitted,
  ),
  Order(
    reference: 'ORD-7622',
    placedAt: DateTime(2026, 9, 28),
    total: 1240.00,
    status: OrderStatus.pending,
  ),
];
