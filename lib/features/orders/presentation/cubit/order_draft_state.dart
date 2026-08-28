part of 'order_draft_cubit.dart';

class OrderDraft extends Equatable {
  const OrderDraft({this.customer, this.lines = const []});

  final Customer? customer;
  final List<OrderLineItem> lines;

  bool get isEmpty => lines.isEmpty;

  int get productCount => lines.length;

  double get subtotal => lines.subtotal;

  bool contains(String productId) =>
      lines.any((line) => line.productId == productId);

  OrderDraft copyWith({Customer? customer, List<OrderLineItem>? lines}) =>
      OrderDraft(
        customer: customer ?? this.customer,
        lines: lines ?? this.lines,
      );

  @override
  List<Object?> get props => [customer, lines];
}
