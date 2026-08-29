part of 'order_draft_cubit.dart';


class DraftEntry extends Equatable {
  const DraftEntry({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  int get available => product.stockUnits;

  bool get isAtStockLimit => quantity >= available;

  OrderLineItem get lineItem =>
      OrderLineItem.fromProduct(product, quantity: quantity);

  DraftEntry withQuantity(int quantity) =>
      DraftEntry(product: product, quantity: quantity);

  @override
  List<Object?> get props => [product, quantity];
}


class OrderDraft extends Equatable {
  const OrderDraft({this.customer, this.entries = const []});

  final Customer? customer;
  final List<DraftEntry> entries;

  List<OrderLineItem> get lines => [for (final entry in entries) entry.lineItem];

  bool get isEmpty => entries.isEmpty;

  int get productCount => entries.length;

  double get subtotal => lines.subtotal;

  bool contains(String productId) =>
      entries.any((entry) => entry.product.id == productId);

  OrderDraft copyWith({Customer? customer, List<DraftEntry>? entries}) =>
      OrderDraft(
        customer: customer ?? this.customer,
        entries: entries ?? this.entries,
      );

  @override
  List<Object?> get props => [customer, entries];
}
