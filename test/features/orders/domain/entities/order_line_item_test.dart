import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sales_pal/features/products/domain/entities/product.dart';

const _coffee = Product(
  id: 'PRD-001',
  name: 'Organic Premium Roast Coffee (1kg)',
  imagePath: 'assets/images/img_product_sample.png',
  stockUnits: 112,
  price: 24.50,
);

void main() {
  group('OrderLineItem', () {
    test('fromProduct copies the name and price, starting at one', () {
      final line = OrderLineItem.fromProduct(_coffee);

      expect(line.productId, _coffee.id);
      expect(line.productName, _coffee.name);
      expect(line.unitPrice, _coffee.price);
      expect(line.quantity, 1);
    });

    test('keeps the price it was created at when the product changes', () {
      final line = OrderLineItem.fromProduct(_coffee);
      const repriced = Product(
        id: 'PRD-001',
        name: 'Organic Premium Roast Coffee (1kg)',
        imagePath: 'assets/images/img_product_sample.png',
        stockUnits: 112,
        price: 31.00,
      );

      expect(line.unitPrice, isNot(repriced.price));
      expect(line.unitPrice, 24.50);
    });

    test('total multiplies unit price by quantity', () {
      expect(OrderLineItem.fromProduct(_coffee, quantity: 2).total, 49.00);
    });

    test('copyWith changes only the quantity', () {
      final line = OrderLineItem.fromProduct(_coffee).copyWith(quantity: 4);

      expect(line.quantity, 4);
      expect(line.productName, _coffee.name);
      expect(line.total, 98.00);
    });

    test('subtotal sums every line', () {
      final lines = [
        OrderLineItem.fromProduct(_coffee, quantity: 2),
        const OrderLineItem(
          productId: 'PRD-002',
          productName: 'Extra Virgin Olive Oil (750ml)',
          unitPrice: 18.90,
          quantity: 1,
        ),
        const OrderLineItem(
          productId: 'PRD-003',
          productName: 'Whole Grain Wheat Crackers (200g)',
          unitPrice: 4.25,
          quantity: 3,
        ),
      ];

      expect(AppFormat.currency(lines.subtotal), '₦80.65');
    });

    test('subtotal of an empty basket is zero', () {
      expect(<OrderLineItem>[].subtotal, 0);
    });
  });
}
