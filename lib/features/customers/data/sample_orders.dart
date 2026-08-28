import '../../orders/domain/entities/order.dart';
import '../../orders/domain/entities/order_line_item.dart';

/// Placeholder history for the customer details screen. Retired in step 4,
/// when it reads `OrderRepository.ordersForCustomer` instead.
final sampleOrders = <Order>[
  Order(
    reference: 'FF-2026-9281',
    customerId: 'CUS-001',
    customerName: 'Acme Groceries Ltd.',
    placedAt: DateTime(2026, 8, 24),
    status: OrderStatus.submitted,
    lines: const [
      OrderLineItem(
        productId: 'PRD-001',
        productName: 'Organic Premium Roast Coffee (1kg)',
        unitPrice: 24.50,
        quantity: 4,
      ),
      OrderLineItem(
        productId: 'PRD-005',
        productName: 'Basmati Rice (5kg)',
        unitPrice: 32.00,
        quantity: 6,
      ),
    ],
  ),
  Order(
    reference: 'FF-2026-8911',
    customerId: 'CUS-001',
    customerName: 'Acme Groceries Ltd.',
    placedAt: DateTime(2026, 8, 10),
    status: OrderStatus.submitted,
    lines: const [
      OrderLineItem(
        productId: 'PRD-002',
        productName: 'Extra Virgin Olive Oil (750ml)',
        unitPrice: 18.90,
        quantity: 10,
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
    ],
  ),
];
