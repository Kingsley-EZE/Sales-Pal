
enum OrderStatus {
  pending,
  submitted,
}

class Order {
  const Order({
    required this.reference,
    required this.placedAt,
    required this.total,
    required this.status,
  });

  final String reference;
  final DateTime placedAt;
  final double total;
  final OrderStatus status;
}
