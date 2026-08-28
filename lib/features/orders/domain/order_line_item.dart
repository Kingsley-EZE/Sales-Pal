import '../../products/domain/entities/product.dart';

class OrderLineItem {
  const OrderLineItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get total => product.price * quantity;
}

extension OrderLineItems on List<OrderLineItem> {
  double get subtotal =>
      fold(0, (runningTotal, item) => runningTotal + item.total);
}
