enum OrderStatus {
  pending,
  submitted,
}

class Order {
  const Order({
    required this.reference,
    required this.customerName,
    required this.placedAt,
    required this.itemCount,
    required this.total,
    required this.status,
  });

  final String reference;
  final String customerName;
  final DateTime placedAt;
  final int itemCount;
  final double total;
  final OrderStatus status;
}
