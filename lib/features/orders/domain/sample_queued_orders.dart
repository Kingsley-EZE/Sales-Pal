import '../../customers/domain/entities/order.dart';

final sampleQueuedOrders = <Order>[
  Order(
    reference: 'ORD-9412',
    customerName: 'Bayside Gourmet Store',
    placedAt: DateTime(2026, 10, 24),
    itemCount: 2,
    total: 450.00,
    status: OrderStatus.pending,
  ),
  Order(
    reference: 'ORD-9408',
    customerName: 'Acme Groceries Ltd.',
    placedAt: DateTime(2026, 10, 24),
    itemCount: 3,
    total: 87.10,
    status: OrderStatus.pending,
  ),
  Order(
    reference: 'ORD-9377',
    customerName: 'Downtown Bistro',
    placedAt: DateTime(2026, 10, 22),
    itemCount: 8,
    total: 512.20,
    status: OrderStatus.pending,
  ),
];
