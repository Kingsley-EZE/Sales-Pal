import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';


class OrderLineItem extends Equatable {
  const OrderLineItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  OrderLineItem.fromProduct(Product product, {this.quantity = 1})
    : productId = product.id,
      productName = product.name,
      unitPrice = product.price;

  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  double get total => unitPrice * quantity;

  OrderLineItem copyWith({int? quantity}) => OrderLineItem(
    productId: productId,
    productName: productName,
    unitPrice: unitPrice,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [productId, productName, unitPrice, quantity];
}

extension OrderLineItems on List<OrderLineItem> {
  double get subtotal =>
      fold(0, (runningTotal, item) => runningTotal + item.total);
}
