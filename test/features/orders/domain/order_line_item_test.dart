import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/features/orders/domain/order_line_item.dart';
import 'package:sales_pal/features/orders/domain/sample_line_items.dart';

void main() {
  group('OrderLineItem', () {
    test('total multiplies unit price by quantity', () {
      expect(sampleLineItems.first.total, 49.00);
    });

    test('subtotal sums every line', () {
      expect(AppFormat.currency(sampleLineItems.subtotal), '₦80.65');
    });

    test('subtotal of an empty basket is zero', () {
      expect(<OrderLineItem>[].subtotal, 0);
    });
  });
}
