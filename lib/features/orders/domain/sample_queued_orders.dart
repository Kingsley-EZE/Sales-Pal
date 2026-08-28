import 'entities/order.dart';
import 'entities/order_line_item.dart';


final sampleQueuedOrders = <Order>[
  Order(
    reference: 'FF-2026-9412',
    customerId: 'CUS-003',
    customerName: 'Bayside Gourmet Store',
    placedAt: DateTime(2026, 8, 24),
    status: OrderStatus.pending,
    lines: const [
      OrderLineItem(
        productId: 'PRD-005',
        productName: 'Basmati Rice (5kg)',
        unitPrice: 32.00,
        quantity: 10,
      ),
      OrderLineItem(
        productId: 'PRD-008',
        productName: 'Cold Pressed Orange Juice (1L)',
        unitPrice: 7.35,
        quantity: 6,
      ),
    ],
  ),
  Order(
    reference: 'FF-2026-7622',
    customerId: 'CUS-001',
    customerName: 'Acme Groceries Ltd.',
    placedAt: DateTime(2026, 7, 28),
    status: OrderStatus.pending,
    lines: const [
      OrderLineItem(
        productId: 'PRD-004',
        productName: 'Unsweetened Almond Milk (1L)',
        unitPrice: 5.10,
        quantity: 12,
      ),
      OrderLineItem(
        productId: 'PRD-007',
        productName: 'Sparkling Water (12 x 500ml)',
        unitPrice: 9.60,
        quantity: 8,
      ),
    ],
  ),
  Order(
    reference: 'FF-2026-9377',
    customerId: 'CUS-004',
    customerName: 'Downtown Bistro',
    placedAt: DateTime(2026, 8, 22),
    status: OrderStatus.pending,
    lines: const [
      OrderLineItem(
        productId: 'PRD-001',
        productName: 'Organic Premium Roast Coffee (1kg)',
        unitPrice: 24.50,
        quantity: 8,
      ),
      OrderLineItem(
        productId: 'PRD-006',
        productName: 'Dark Chocolate Bars (Case of 24)',
        unitPrice: 41.75,
        quantity: 3,
      ),
    ],
  ),
];
