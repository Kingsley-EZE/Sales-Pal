import 'package:equatable/equatable.dart';

import 'order_line_item.dart';

enum OrderStatus { pending, submitted }

class Order extends Equatable {
  const Order({
    required this.reference,
    required this.customerId,
    required this.customerName,
    required this.placedAt,
    required this.status,
    required this.lines,
  });

  final String reference;
  final String customerId;
  final String customerName;
  final DateTime placedAt;
  final OrderStatus status;
  final List<OrderLineItem> lines;

  int get itemCount => lines.length;

  double get total => lines.subtotal;

  bool get isPending => status == OrderStatus.pending;

  Order copyWith({OrderStatus? status}) => Order(
    reference: reference,
    customerId: customerId,
    customerName: customerName,
    placedAt: placedAt,
    status: status ?? this.status,
    lines: lines,
  );

  @override
  List<Object?> get props => [
    reference,
    customerId,
    customerName,
    placedAt,
    status,
    lines,
  ];
}
