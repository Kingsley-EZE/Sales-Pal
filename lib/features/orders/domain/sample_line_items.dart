import '../../products/domain/entities/product.dart';
import 'order_line_item.dart';

final sampleLineItems = <OrderLineItem>[
  OrderLineItem(
    product: const Product(
      id: 'PRD-001',
      name: 'Organic Premium Roast Coffee (1kg)',
      imagePath: 'assets/images/img_product_sample.png',
      stockUnits: 112,
      price: 24.50,
    ),
    quantity: 2,
  ),
  OrderLineItem(
    product: const Product(
      id: 'PRD-002',
      name: 'Extra Virgin Olive Oil (750ml)',
      imagePath: 'assets/images/img_product_sample.png',
      stockUnits: 45,
      price: 18.90,
    ),
    quantity: 1,
  ),
  OrderLineItem(
    product: const Product(
      id: 'PRD-003',
      name: 'Whole Grain Wheat Crackers (200g)',
      imagePath: 'assets/images/img_product_sample.png',
      stockUnits: 320,
      price: 4.25,
    ),
    quantity: 3,
  ),
];
