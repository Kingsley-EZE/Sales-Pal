import '../../products/domain/sample_products.dart';
import 'order_line_item.dart';

final sampleLineItems = <OrderLineItem>[
  OrderLineItem(product: sampleProducts[0], quantity: 2),
  OrderLineItem(product: sampleProducts[1], quantity: 1),
  OrderLineItem(product: sampleProducts[2], quantity: 3),
];
